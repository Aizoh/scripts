
# Setting up METABASE as a Service in Debian
Metabase is a very powerful tool for data analysis, reporting and visualization.
## [Procedure](https://www.metabase.com/docs/latest/installation-and-operation/running-metabase-on-debian)
The key steps in this startup process are as follows:
**prerequisite**
- Installed Java on your Debian server.

- Have a sudo Account on your Server.

- Create a Metabase Directory in your Server and move the downloaded metabase Jar version to that Directory. In this case inside the user I create a directoy called metabase and putt the file there, such that I run the metabase from that user. Alternatively see the step of creating a metabase user.

- Installed Web servers either Apache/ Nginx in this case I will Apache As I intend to use Maria DB.


1. Create an unprivileged user to run Metabase and give him acces to app and logs.

We will call the user simply metabase.

```bash 
sudo groupadd -r metabase
sudo useradd -r -s /bin/false -g metabase metabase
sudo chown -R metabase:metabase </your/path/to/metabase/directory>
sudo touch /var/log/metabase.log
sudo chown syslog:adm /var/log/metabase.log
sudo touch /etc/default/metabase
sudo chmod 640 /etc/default/metabase

# creating the user group, adding the user metabase to the group, changing ownership of the metabase dir and the logs

```

2. Create a Metabase Service

Services are typically registered at */etc/systemd/system/<servicename>*. So, a Metabase service should live at */etc/systemd/system/metabase.service*.

```bash
sudo touch /etc/systemd/system/metabase.service
sudo nano /etc/systemd/system/metabase.service

#THis will open up the file .   since i placed the metabase within the user(gitau) folder for my metabase.                                                         
[Unit]
Description=Metabase service
After=syslog.target

[Service]
WorkingDirectory=/home/gitau/metabase
ExecStart=/usr/bin/java -jar /home/gitau/metabase/metabase.jar
EnvironmentFile=/etc/default/metabase
User=gitau
Type=simple
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=metabase
SuccessExitStatus=143
TimeoutStopSec=120
Restart=always

[Install]
WantedBy=multi-user.target

#WorkingDirectory=</your/path/to/metabase/directory/>
#ExecStart=/usr/bin/java -jar </your/path/to/metabase/directory/>metabase.jar
```

3. Create a syslog conf 

This is to help handle logging 

```bash
sudo touch /etc/rsyslog.d/metabase.conf
sudo nano /etc/rsyslog.d/metabase.conf

if $programname == 'metabase' then /var/log/metabase.log
& stop
#Restart the syslog service to load the new config.
sudo systemctl restart rsyslog.service

```

4. Metabase Enviromental Variables

Customize and configure your Metabase instance on your server. On Debian systems, services typically expect to have accompanying configs inside *etc/default/<service-name>*.Remember we had set up the environmental variable at the metabase service file above.**Step 2**.

Open Metabase Config file:

```bash
sudo nano /etc/default/metabase

```
Configure the environment variables by default it'll look like:
```bash 
MB_PASSWORD_COMPLEXITY=<weak|normal|strong>
MB_PASSWORD_LENGTH=<10>
MB_JETTY_HOST=<0.0.0.0>
MB_JETTY_PORT=<12345>
MB_DB_TYPE=<postgres|mysql|h2>
MB_DB_DBNAME=<your_metabase_db_name>
MB_DB_PORT=<5432>
MB_DB_USER=<your_metabase_db_user>
MB_DB_PASS=<ssshhhh>
MB_DB_HOST=<localhost>
MB_EMOJI_IN_LOGS=<true|false>
# any other env vars you want available to Metabase

```
Edit the file to appear like

```bash 
MB_PASSWORD_COMPLEXITY=weak
MB_PASSWORD_LENGTH=4
MB_JETTY_HOST=0.0.0.0
MB_JETTY_PORT=3000
MB_DB_TYPE=mysql
MB_DB_DBNAME=metabase
MB_DB_PORT=3306
MB_DB_USER=root
MB_DB_PASS=root
MB_DB_HOST=localhost
MB_EMOJI_IN_LOGS=true
# any other env vars you want available to Metabase

#here I don't want to force users for too strict and long passwords 
#am using default port 3000 for metabase
#using mysql database at it's default port, and I have created a database called metabase
#i then supply the db credentials # let's assume we say it's root, root
```


5. Register your Metabase service
Now, it’s time to register our Metabase service with systemd so it will start up at system boot. 

```bash
sudo systemctl daemon-reload
sudo systemctl start metabase.service
sudo systemctl status metabase.service

```
To enable metabase to always restart on system boot 
```bash
sudo systemctl enable metabase.service

```
### troubleshooting Metabase 
Restart, stop or start service

```bash
sudo systemctl start metabase.service
sudo systemctl stop metabase.service
sudo systemctl restart metabase.service

```

## Set up troubleshooting
If metabse is failing 
- Try to set up Nginx to proxy requests to Metabase
The nginx.conf below assumes you are accepting incoming traffic on port 80 and want to proxy requests to Metabase, and that your Metabase instance is configured to run on localhost at port 3000. 
Edit nginx config
```bash
    sudo nano etc/nginx/nginx.conf
```
Edit the file and insert the code block below within the http{}

```bash
server {
  listen 8081;
  listen [::]:8081;
  server_name your.domain.com;
  location / {
    proxy_pass http://127.0.0.1:3000;
  }
}


#in my case port 80, is forwarded and in use in other programs so I use port 8081 instead. I pass to the same port we set up at the MB_JETTY_PORT=3000 environmental variables
```
- Or Set up Apache to listen to to the specific port you set
Edit nginx config
```bash
    sudo nano etc/apache2/ports.conf
```
Edit the file and insert the code block below 

```bash
Listen 3000

#then 
sudo systemctl reload apache2
```
### Usage
You can now go ahead and explore creating queries, databases, users and so much more including data visualization .
*intresting feature dashboard sharing ny enabling public sharing* then iframes to your website/app
example of an iframe
```html
<iframe
    id="metabaseIframe"
    src="http://ip:3000/public/dashboard/de180476-991a-4373-80ae-ec96af9944b0#refresh=120"
    frameborder="0"
    width="100%"
    height="1000"
    allowtransparency
></iframe>
<!-- the src is a public sharing link  with live data abd a refresh rate of 120 seconds -->
```
### Upgrade

If your Metabase is running, stop the Metabase process.
Move the old jar file to a different location and replace it ewith the new jar file 
then start the service. [see](https://www.metabase.com/docs/latest/installation-and-operation/backing-up-metabase-application-data)

## Migrating from H2 db to Mysql 

 migrate the app database from H2 to a production database such as PostgreSQL or MySQL/MariaDB using the load-from-h2 command, but this has failed because the database filename is incorrect with an error message like:

1. Create a copy of the exported H2 database [See Backing up Metabase Application Data](https://www.metabase.com/docs/latest/installation-and-operation/backing-up-metabase-application-data). Do not proceed until you have done this in case something goes wrong.

2. Check that the H2 database file you exported is named metabase.db.mv.db.

3. H2 automatically adds .mv.db extension to the database path you specify on the command line, so make sure the path to the DB file you pass to the command does not include the .mv.db extension. For example, if you’ve exported an application database, and you want to load the data from that H2 database into a PostgreSQL database using load-from-h2, your command will look something like:

```bash
export MB_DB_TYPE=mysql
export MB_DB_DBNAME=metabase
export MB_DB_PORT=3306
export MB_DB_USER=username
export MB_DB_PASS=password
export MB_DB_HOST=localhost/ip
java -jar metabase.jar load-from-h2 /path/to/metabase.db # do not include .mv.db #run from where the working directory is with the jar file

```
### issues arising 
```html
<p>
Transfering 15 instances of Setting....BatchUpdateException:<br>
 Message: (conn=1101) Data too long for column 'value' at row 1<br>
 SQLState: 22001<br>
 Error Code: 1406<br>
java.sql.BatchUpdateException: (conn=1101) Data too long for column 'value' at row 1<br>
Command failed with exception: (conn=1101) Data too long for column 'value' at row 1</p>
<strong><p>Edited the settings table adjusted the value field type from TEXT to LONGTEXT</p></strong>

```
In the Metabase service config 

```bash
nano /etc/systemd/system/metabase.service #edit

[Unit]
Description=Metabase applicaion service
Documentation=https://www.metabase.com/docs/latest

[Service]
WorkingDirectory=/apps/java
ExecStart=/usr/bin/java -jar /apps/java/metabase.jar
EnvironmentFile=/etc/default/metabase #add this and create this config file
User=metabaseuserused
Type=simple
Restart=on-failure
RestartSec=10
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=metabase
SuccessExitStatus=143
TimeoutStopSec=120
Restart=always

[Install]
WantedBy=multi-user.target

```
Inside the Env file 

```bash 
sudo nano /etc/default/metabase
#MB_PASSWORD_COMPLEXITY=weak
#MB_PASSWORD_LENGTH=4
#MB_JETTY_HOST=0.0.0.0
#MB_JETTY_PORT=3000
MB_DB_TYPE=mysql
MB_DB_DBNAME=metabase
MB_DB_PORT=3306
MB_DB_USER=user
MB_DB_PASS=password
MB_DB_HOST=localhost/ip 

```
Restart systems

```bash
systemctl daemon-reload
service metabase start
systemctl status metabase.service

```

### Explore
To learn more explore the [Metabase Documentation](https://www.metabase.com/docs/latest/).
Happy Analysis