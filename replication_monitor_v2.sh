#!/bin/bash

# MySQL Credentials
MYSQL_USER="user"
MYSQL_PASSWORD="userpass"
MYSQL_HOST="ip"  # Change to the appropriate MySQL host
DATABASE_NAME="dbname"  

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
