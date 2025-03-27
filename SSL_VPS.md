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


