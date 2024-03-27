## creating a datatbase replication monitor cron to alert incase replication fails to send out email notifications.
Note that you'll have to configure mailing withn the server first. to understand more about bash scripting see the pdf within this repo.

These are 2 versions one alerts only when replication lags anfd not if there's an I/O error while the other one does alert incase there is an error.

- ** lag and error **
```bash

#!/bin/bash

# MySQL Credentials
MYSQL_USER="user"
MYSQL_PASSWORD="pass"
MYSQL_HOST="ip"  # Change to the appropriate MySQL host
DATABASE_NAME="db"  

# Threshold in seconds (1 hour = 3600 seconds)
THRESHOLD=3600

# Get the current replication lag in seconds for the specific database
REP_LAG=$(mysql -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" -h"${MYSQL_HOST}" -e "USE ${DATABASE_NAME}; SHOW SLAVE STATUS\G" | awk '/Seconds_Behind_Master/ {print $2}')

# Check if replication lag exceeds the threshold or is NULL
if [ -n "$REP_LAG" ] && [ "$REP_LAG" != "NULL" ] && [ "$REP_LAG" -gt "$THRESHOLD" ]; then
    # Send an email notification
    echo "Replication lag is greater than 1 hour. Lag: $REP_LAG seconds" | mail -s "Replication Lag Alert" email_to_send_to
elif [ -z "$REP_LAG" ] || [ "$REP_LAG" = "NULL" ]; then
    # Handle the case where "Seconds_Behind_Master" is null
    echo "Replication lag information is not available. Check MySQL replication status." | mail -s "Replication Lag Alert" email_to_send_to
fi

# Error handling
if [ $? -ne 0 ]; then
    echo "Error: Failed to fetch replication lag information." >&2
    exit 1
fi

#####now for the CRON 

#make it executable
chmod +x check_replication.sh
 #ecdit cron
crontab -e

0 */3 * * 1-6 /path/to/check_replication.sh
```

- ** just error **
```bash

#!/bin/bash SCRIPT

# MySQL Credentials
MYSQL_USER="user"
MYSQL_PASSWORD="pass"
MYSQL_HOST="ip"  # Change to the appropriate MySQL host
DATABASE_NAME="db"  

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
chmod +x check_replication.sh
 #ecdit cron
crontab -e

0 */3 * * 1-6 /path/to/check_replication.sh
```