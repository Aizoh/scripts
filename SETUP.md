## SERVER SET UP
SETTING UP A SERVER

0. ### system hardening ###

```bash
    #disable root ssh Login 
    sudo passwd -l root #sudo passwd -u root to enable
    #edit sudo nano /etc/ssh/sshd_config
    PermitRootLogin no
    AllowUsers yoursshuser
    # Use public key authentication only (disable passwords)
    PasswordAuthentication no
    ChallengeResponseAuthentication no
    UsePAM yes

    # Optional: limit login attempts
    MaxAuthTries 3

    # Disable empty passwords
    PermitEmptyPasswords no

    # Keep SSH alive connections shorter to avoid hanging sessions
    ClientAliveInterval 300
    ClientAliveCountMax 2
    #on local pc
    ssh-keygen -t ed25519 -C "user@server"
    #copy to server 
    ssh-copy-id user@your_server_ip


    ssh-keygen -f "/home/user/.ssh/known_hosts" -R "serverip"

    #add ufw firewall rules 
    sudo ufw allow ssh
    sudo ufw allow http
    sudo ufw allow https
    #enable firewall
    sudo ufw status
    sudo ufw enable

    #install an audit tool
    sudo apt install lynis
    sudo lynis audit system

    # Edit 

    #install fail2ban 
    sudo apt update
sudo apt install fail2ban -y
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
```
## [NGINX START](https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-22-04)

```bash

#in production just create a different directory for your site instead of the html Only user and www-data can read/write. Others have no access.

#Separate user for deployment: You can create a dedicated user for deploying Laravel projects, and make www-data the group.
sudo mkdir -p /var/www/sitename
sudo chown -R user:www-data /var/www/sitename
sudo chmod -R 750 /var/www/sitename
cd /var/www/sitename
git clone https://github.com.


#For Laravel specifically, you’ll later allow Nginx write access to storage and cache:
sudo chown -R www-data:www-data /var/www/sitename/storage /var/www/sitename/bootstrap/cache
sudo chmod -R 775 /var/www/sitename/storage /var/www/sitename/bootstrap/cache

#see enabled sites
ls -l /etc/nginx/sites-enabled/

#to disable 
sudo unlink /etc/nginx/sites-enabled/site

#test Nginx 
sudo nginx -t

#reload 
sudo systemctl reload nginx



sudo ln -s /etc/nginx/sites-available/sitename /etc/nginx/sites-enabled/
#in the config prevent execution from storage folder 
location ~* /storage/.*\.(php|pl|py|sh)$ {
    deny all;
}
#to deal with 504 gateway timeout if using fpm
#Edit /etc/php/8.2/fpm/pool.d/www.conf:
pm = dynamic
pm.max_children = 20    # adjust depending on RAM
pm.start_servers = 5
pm.min_spare_servers = 5
pm.max_spare_servers = 10
sudo systemctl restart php8.2-fpm

#also Edit your site config (e.g., /etc/nginx/sites-available/your-site) and add/increase:
location ~ \.php$ {
    fastcgi_pass unix:/run/php/php8.2-fpm.sock;
    fastcgi_read_timeout 120s;   # default is 60s
    include fastcgi_params;
}
#monitor live php fpm 
sudo watch -n 2 "ps -o pid,cmd,rss -C php-fpm8.2"


```

## more 

Great — let’s add Fail2Ban protection to automatically ban IPs that try to execute PHP files inside /storage or probe for webshells.

This will block repeated malicious requests like:

/storage/bootstrap.cache.php
/storage/shell.php
/.env
🛡️ Step 1 — Create Fail2Ban Filter for Nginx Attacks
sudo nano /etc/fail2ban/filter.d/nginx-webshell.conf

Paste:

[Definition]
failregex = ^<HOST> -.*"(GET|POST).*\.php.*" 403
            ^<HOST> -.*"(GET|POST).*/storage/.*" 404
            ^<HOST> -.*"(GET|POST).*\.env" 403
            ^<HOST> -.*"(GET|POST).*wp-content\.php" 403
ignoreregex =

This catches:

attempts to run /storage/*.php

probing .env

common injected filenames like wp-content.php

🛡️ Step 2 — Create Jail Configuration
sudo nano /etc/fail2ban/jail.d/nginx-webshell.local

Paste:

[nginx-webshell]
enabled = true
filter = nginx-webshell
port = http,https
logpath = /var/log/nginx/web_access.log
maxretry = 3
findtime = 600
bantime = 3600
Meaning:

3 malicious requests → banned

ban lasts 1 hour

watches only your site logs

🔄 Step 3 — Restart Fail2Ban
sudo systemctl restart fail2ban
sudo fail2ban-client status nginx-webshell

You should see:

Status for the jail: nginx-webshell
🔎 Step 4 — Test It (Safe Simulation)

Run:

curl -I http://weburl/storage/test.php
curl -I http://weburl.env

After 3 tries, your IP should be banned:

sudo fail2ban-client status nginx-webshell
🚨 Optional (Stronger Ban — Recommended)

Ban immediately if any PHP is requested inside /storage:

Edit filter:

sudo nano /etc/fail2ban/filter.d/nginx-webshell.conf

Replace with:

[Definition]
failregex = ^<HOST> -.*"(GET|POST).*/storage/.*\.php.*"
ignoreregex =

Now 1 request = instant ban.

1. **Prerequisites**


### SET UP NEW USER ACCOUNTS
```bash
ssh root@your_server_ip_address

adduser myuser

#Adding the User to the sudo Group
usermod -aG sudo myuser

#reset passowrd as root
passwd username
 

```
### INSTALL  MYSQL SERVER

```bash
sudo apt update
sudo apt install mysql-server
sudo systemctl start mysql.service

```
### SET UP USER AND PASSWORDS AND GRANT PRIVILLEGES
```bash
sudo mysql
```
```sql
/*USING NATIVE COMMON*/
CREATE USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';
/**Global access */
CREATE USER 'user'@'%' IDENTIFIED WITH mysql_native_password BY 'password';
GRANT ALL PRIVILEGES ON *.* TO 'user'@'%' WITH GRANT OPTION;

/*FOR MYSQL 8.0 AND ABOVE */
CREATE USER 'username'@'host' IDENTIFIED WITH authentication_plugin BY 'password';

/*TO ALTER*/
ALTER USER 'sammy'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';

/*GRANT PRIVILEGES*/
GRANT ALL PRIVILEGES ON *.* TO 'sammy'@'localhost' WITH GRANT OPTION;

FLUSH PRIVILEGES;

/**For older systems use  */
SET PASSWORD FOR 'user'@'localhost' = PASSWORD('password');
FLUSH PRIVILEGES;

exit

/*in terminal now to login as the user*/
mysql -u sammy -p

```
### INSTALL APACHE2 & PHP
```bash

sudo apt install apache2

#INSTALL PHP
sudo apt install php libapache2-mod-php php-mysql

```
### INSTALL PHP MYADMIN

```bash
#note the php admin installed will be the version compatible with your current selected php cli. 
#That's the PHP version which apache should be set to run so as run php myadmin , then set your applications to run on FPM
sudo apt install phpmyadmin php-mbstring php-zip php-gd php-json php-curl
#note in set up click space to select apache 2 when selecting the web server
```

### PHP AND [FPM](https://www.digitalocean.com/community/tutorials/how-to-run-multiple-php-versions-on-one-server-using-apache-and-php-fpm-on-ubuntu-20-04) see 

```bash
sudo apt-get install software-properties-common -y

sudo add-apt-repository ppa:ondrej/php

sudo apt-get update -y

# Install PHP 5.6
sudo apt-get install php5.6 php5.6-fpm php5.6-mysql libapache2-mod-php5.6 libapache2-mod-fcgid -y

# Install PHP 7.0
sudo apt-get install php7.0 php7.0-fpm php7.0-mysql libapache2-mod-php7.0 libapache2-mod-fcgid -y

# Install PHP 7.1
sudo apt-get install php7.1 php7.1-fpm php7.1-mysql libapache2-mod-php7.1 libapache2-mod-fcgid -y

# Install PHP 7.2
sudo apt-get install php7.2 php7.2-fpm php7.2-mysql libapache2-mod-php7.2 libapache2-mod-fcgid -y

# Install PHP 7.3
sudo apt-get install php7.3 php7.3-fpm php7.3-mysql libapache2-mod-php7.3 libapache2-mod-fcgid -y

# Install PHP 7.4
sudo apt-get install php7.4 php7.4-fpm php7.4-mysql libapache2-mod-php7.4 libapache2-mod-fcgid -y

# Install PHP 8.0
sudo apt-get install php8.0 php8.0-fpm php8.0-mysql libapache2-mod-php8.0 libapache2-mod-fcgid -y

# Install PHP 8.1
sudo apt-get install php8.1 php8.1-fpm php8.1-mysql libapache2-mod-php8.1 libapache2-mod-fcgid -y

# Install PHP 8.2
sudo apt-get install php8.2 php8.2-fpm php8.2-mysql libapache2-mod-php8.2 libapache2-mod-fcgid -y

# Install PHP 8.3
sudo apt-get install php8.3 php8.3-fpm php8.3-mysql libapache2-mod-php8.3 libapache2-mod-fcgid -y

# do not under any circumstance  a2enconf phpx.x-fpm after installing if you do kindly disable it a2disconf phpx.x-fpm
#This is because it'll force apache to run on fpm instead do 
sudo systemctl start phpx.x-fpm #after every php installation

#allow apache to work with mutiple fpm
sudo a2enmod actions fcgid alias proxy_fcgi

#set apache php version
sudo a2enmod phpx.x 
#to disable and enable a different version then enmod that version
sudo a2dismod phpx.x

#restart apache 
sudo systemctl restart apache2 # or 
sudo service apache2 restart

#change cli PHP
sudo update-alternatives --config php
```
### INSTALL COMPOSER
```bash
curl -sS https://getcomposer.org/installer -o composer-setup.php
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
sudo composer self-update

```

## FPM adjustements
 `/etc/php/8.2/fpm/php.ini` & `/etc/php/8.2/fpm/pool.d/www.conf` files 

