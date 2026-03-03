##  SERVER SET UP
SETTING UP A CERTBOT with Let's Encrypt

1. **Prerequisites**

### SET UP DOMAIN & HOSTING

- Register a domain (Name Cheap)
- Edit the Domain Name Servers to Point to Your Preffered Hosting Provider (in this case Contabo)
- Add the Domian in the Contabo Domain List and relate it with the KVM

- To add a subdomain edit the existing domain 
    - under Name : put your subdomain name
    - under Data : put your KVM ip address

```bash
#incase you run into issues you can always run this to start over
sudo apt-get remove certbot

sudo apt install certbot python3-certbot-apache
#if using Nginx put Nginx instead this is for Apache 
sudo ufw allow 'Apache Full'
sudo certbot --apache

# see certbot timer as it installs a cronjob for renewal
systemctl status certbot.timer

#stimulate renewal process 
certbot renew --dry-run

```
Inside the virtual config edit to Read  as follows Add the following line incase Http tobe redirected 

```bash
<VirtualHost *:port>
     ServerAdmin admin@subdomain
     ServerName sub.domain.com
     DocumentRoot /var/www/html/folder/public
     

     <Directory /var/www/html/folder/public>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Order allow,deny
        allow from all
     </Directory>

    <FilesMatch \.php$>
        # 2.4.10+ can proxy to unix socket
         SetHandler "proxy:unix:/run/php/php8.2-fpm.sock|fcgi://localhost"
    </FilesMatch>

     ErrorLog ${APACHE_LOG_DIR}/folder_error.log
     CustomLog ${APACHE_LOG_DIR}/folder.com_access.log combined
     #The lines below will be generated once you install the certbot
RewriteEngine on
RewriteCond %{SERVER_NAME} =sub.domain.com
RewriteRule ^ https://%{SERVER_NAME}%{REQUEST_URI} [END,NE,R=permanent]
</VirtualHost>
```
## SSL ON LOCAL 

1. 

```bash
#edit hosts
sudo nano /etc/hosts

127.0.0.1 site.local
127.0.0.1 www.site.local

#install mkcert for ssl
sudo apt install mkcert libnss3-tools
mkcert -install
#generate ssl 
mkcert site.local www.site.local

#move the ssl certs 
sudo mkdir -p /etc/ssl/local

sudo mv site.local+1.pem /etc/ssl/local/site.local.pem
sudo mv site.local+1-key.pem /etc/ssl/local/site.local-key.pem
#secure the keys
sudo chmod 600 /etc/ssl/local/site.local-key.pem
sudo chmod 644 /etc/ssl/local/site.local.pem

#enable ssl
sudo a2enmod ssl

#ensure your virtual host config has the ssl config
sudo nano /etc/apache2/sites-available/site.conf

#

<VirtualHost *:80>
     ServerAdmin admin@site
     ServerName site.local
     ServerAlias www.site.local
    Redirect permanent / https://site.local/

     DocumentRoot /var/www/html/site/public
     

     <Directory /var/www/html/site/public>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Order allow,deny
        allow from all
     </Directory>

    <FilesMatch \.php$>
        # 2.4.10+ can proxy to unix socket
         SetHandler "proxy:unix:/run/php/php8.2-fpm.sock|fcgi://localhost"
    </FilesMatch>

     ErrorLog ${APACHE_LOG_DIR}/site_error.log
     CustomLog ${APACHE_LOG_DIR}/site.com_access.log combined
</VirtualHost>
<VirtualHost *:443>
    ServerAdmin admin@site
    ServerName site.local
    ServerAlias www.site.local
    DocumentRoot /var/www/html/site/public

    SSLEngine on
    SSLCertificateFile /etc/ssl/local/site.local.pem
    SSLCertificateKeyFile /etc/ssl/local/site.local-key.pem

    <Directory /var/www/html/site/public>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Require all granted
    </Directory>

    <FilesMatch \.php$>
        SetHandler "proxy:unix:/run/php/php8.2-fpm.sock|fcgi://localhost"
    </FilesMatch>

    ErrorLog ${APACHE_LOG_DIR}/site_ssl_error.log
    CustomLog ${APACHE_LOG_DIR}/site_ssl_access.log combined
</VirtualHost>


#apache test
sudo apachectl configtest



```
