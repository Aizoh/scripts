## PHP VIRTUAL HOSTS
 Working with differnet php Versions and projects:

1. **Prerequisites**
```bash
#enable a particular php for apache
sudo a2enmod php8.2

#disable one to enable the othwer one
sudo a2dismod php8.3

#change cli PHP
sudo update-alternatives --config php

#check status of PHP-FPM

service php8.2-fpm status

```
