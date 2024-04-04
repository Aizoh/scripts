## creating a databse dump and running cron jobs to delete old dumps.
These are 2 versions one uses the sshkeys hence it wont require user's password in the script to compy and move the file to a different location while the other one uses the ssh keys.

- ** using scp Password **

```bash

#!/bin/bash

# Database credentials
DB_USER="username"
DB_PASSWORD="password"
DB_NAME="database_name"

# Backup directory
BACKUP_DIR="/path/to/local/backup/directory"
REMOTE_BACKUP_DIR="/path/to/remote/backup/directory"
DATE=$(date +"%Y-%m-%d")

# Dump database
mysqldump -u $DB_USER -p$DB_PASSWORD $DB_NAME > $BACKUP_DIR/$DB_NAME-$DATE.sql

# Copy backup file to remote server NB scp requires password for the user
sshpass -p 'remote_password' scp $BACKUP_DIR/$DB_NAME-$DATE.sql user@remote_server:$REMOTE_BACKUP_DIR

# Remove local backup file
rm $BACKUP_DIR/$DB_NAME-$DATE.sql

# Remove backups older than 2 days on remote server
sshpass -p 'remote_password' ssh user@remote_server "find $REMOTE_BACKUP_DIR/* -mtime +2 -exec rm {} \;"

##crontab
chmod +x backup_database.sh
crontab -e

0 0 * * * /path/to/backup_database.sh

```
- ** using shh keys **
```bash
#!/bin/bash

# Database credentials
DB_USER="username"
DB_PASSWORD="password"
DB_NAME="database_name"

# Backup directory where to store the backup within the server
BACKUP_DIR="/path/to/local/backup/directory"
#where to export the dump after creating in the server.
REMOTE_BACKUP_DIR="/path/to/remote/backup/directory"
DATE=$(date +"%Y-%m-%d")

# Dump database
mysqldump -u $DB_USER -p$DB_PASSWORD $DB_NAME > $BACKUP_DIR/$DB_NAME-$DATE.sql

# Copy backup file to remote server for a request not to ask for the password on scp set up ssh-keys
scp $BACKUP_DIR/$DB_NAME-$DATE.sql user@remote_server:$REMOTE_BACKUP_DIR

# Remove local backup file after copying
rm $BACKUP_DIR/$DB_NAME-$DATE.sql

# Remove backups older than 2 days on remote server
ssh user@remote_server "find $REMOTE_BACKUP_DIR/* -mtime +2 -exec rm {} \;"

#check first if you have a key
cat ~/.ssh/id_rsa.pub

#do this first if not generated key
ssh-keygen -t rsa

#if error copy the ssh key manually to the remote server
#sudo ssh-keyscan -t ed25519 177.112.2.120 >> ~/.ssh/known_hosts

sudo ssh-keyscan -t key remoteserver >> ~/.ssh/known_hosts

#facing permission issues run 
sudo chown -R your_username ~/.ssh
sudo chmod 700 ~/.ssh
sudo chmod 644 ~/.ssh/known_hosts
#end

ssh-keyscan -H remote_server >> ~/.ssh/known_hosts

ssh-copy-id user@remote_server

ssh user@remote_server

##crontab
chmod +x backup_database.sh
crontab -e

0 0 * * * /path/to/backup_database.sh

```