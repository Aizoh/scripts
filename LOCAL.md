## LOCAL VIRTUAL CONFIGS

Want to set up a local domain for your Application create a virtual config file and for the sernname name and alias put your alias

```bash
<VirtualHost *:80>
     ServerAdmin admin@app
     ServerName app.local
     ServerAlias www.app.local
    #continue with the relevant configs
```

- Now to enable you site to be reachable locally you have to link your localhost ip with the url(link) the file `/etc/hosts`

```bash
    #include your name binding
    # for localhost
    127.0.0.1 app.local
    127.0.0.1 www.app.local

```

For Nginx

`cd /etc/nginx/sites-available/` create your virtual config there <br>
eg

```bash
 server {
        listen 80;
        listen [::]:80;

        root /var/www/html/app/public;
        index index.php index.html index.htm index.nginx-debian.html;

        server_name app.local www.app.local;

         access_log /var/log/nginx/app_access.log;
        error_log  /var/log/nginx/app_error.log;

        location / {
            try_files $uri $uri/ /index.php?$query_string;
        }

        location ~ \.php$ {
            include snippets/fastcgi-php.conf;
            fastcgi_pass unix:/run/php/php8.3-fpm.sock;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            include fastcgi_params;
        }

        location ~ /\.ht {
            deny all;
        }

}
```

Activate / Enable the site by

```bash
sudo ln -s /etc/nginx/sites-available/app /etc/nginx/sites-enabled/

```

check for any syntax errors in your sites and restart Nginx also edit the `etc/hosts` to ass the server alias

```bash
#ETC HOSTS
203.0.113.5 app.local www.app.local

#NGINX RESTART
sudo nginx -t
sudo systemctl restart nginx

```
