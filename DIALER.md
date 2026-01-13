## MYSQL ANYHOST Access

```bash
sudo firewall-cmd --list-all

sudo firewall-cmd --permanent --add-port=3306/tcp

sudo firewall-cmd --reload

```

Ensure you edit 

```bash
sudo cat /etc/my.cnf
# or
sudo cat /etc/mysql/my.cnf
# or on OpenSUSE
sudo cat /etc/my.cnf.d/mariadb-server.cnf
##find and replace 
[mysqld]
bind-address = 127.0.0.1

#with 
bind-address = 0.0.0.0

sudo systemctl restart mariadb
# or
sudo systemctl restart mysql

```

## campaign stop recording on dead call enabled 

`Dead Call Stop Recording:`

## changed default csv action to download 

```bash

    sudo nano /etc/mime.types
    #replace text/x-comma-separated-values    csv with text/csv    csv

#2️⃣ Force download globally for CSV (recommended)
sudo nano /etc/apache2/conf.d/csv-download.conf
#add 
<IfModule mod_headers.c>
    <FilesMatch "\.csv$">
        Header set Content-Type "text/csv"
        Header set Content-Disposition "attachment"
    </FilesMatch>
</IfModule>
# then 
sudo a2enmod headers
sudo systemctl reload apache2


```
## Make recordings Accessible 

recordings are accessed vai a symnlink in `/etc/apache2/conf.d/vicirecord.conf`
make the directory refferenced executable by apache 

```bash
chmod 755 /var/spool/asterisk

```