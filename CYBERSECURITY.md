## Ghost SMTP MAILER

```bash
#LOcate 
ss -antp | grep ':25'

#find the process and kill it 

kill -9 processid
#confirm again 
ss -antp | grep ':25'

#if it comes back find its persintence from where it resides 

ls -l /proc/processid/exe



DENY PORT 25

ufw deny out 25

EST OPTION (strongly recommended): SSH TUNNELING

This is the industry-standard solution when you don’t have a static IP.

How it works

MySQL stays bound to localhost

Port 3306 is NOT exposed

You connect securely over SSH

Step 1: Lock MySQL to localhost

In /etc/mysql/mysql.conf.d/mysqld.cnf:

bind-address = 127.0.0.1


Restart:

systemctl restart mysql

Step 2: Close MySQL port in UFW
ufw delete allow 3306

Step 3: Connect remotely via SSH tunnel
From your local machine:
#ssh -L 3306:127.0.0.1:3306 user@ip
# Use port 3307 instead
ssh -L 3307:127.0.0.1:3306 -N -f user@ip

Now connect using:

Host: 127.0.0.1

Port: 3306

Username: MySQL user

Password: MySQL password

Works in:

MySQL CLI

DBeaver

MySQL Workbench

HeidiSQL

phpMyAdmin (via local browser)
```
🔒 Secure
🌍 Works from any IP
🚀 Zero firewall exposure