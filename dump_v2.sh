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

#make executable
chmod +x dump_v2.sh

#crontab
crontab -e

0 0 * * * /path/to/chmod +x dump_v2.sh
