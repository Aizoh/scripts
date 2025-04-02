## SERVER SET UP
SETTING UP A SERVER

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
