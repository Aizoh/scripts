#!/bin/bash SCRIPT

# MySQL Credentials
MYSQL_USER="user"
MYSQL_PASSWORD="pass"
MYSQL_HOST="ip"  # Change to the appropriate MySQL host
DATABASE_NAME="dbname"  

# Threshold in seconds (3 hours = 10800 seconds)
THRESHOLD=10800

# Get the current replication lag in seconds for the specific database
REP_LAG=$(mysql -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" -h"${MYSQL_HOST}" -e "USE ${DATABASE_NAME}; SHOW SLAVE STATUS\G" | grep "Seconds_Behind_Master" | awk '{print $2}')


# Check if replication lag exceeds the threshold
if [ "$REP_LAG" -gt "$THRESHOLD" ]; then
    # Send an email notification
    echo "Replication lag is greater than 3 hours. Lag: $REP_LAG seconds" | mail -s "Replication Lag Alert" your@email.com
fi

#####now for the CRON 

#make it executable
chmod +x replication_monitor.sh
 #ecdit cron
crontab -e

0 */3 * * 1-6 /path/to/replication_monitor.sh
