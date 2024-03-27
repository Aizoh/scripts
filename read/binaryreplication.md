
# setting up Binary Replication
For a complete guide and guidance visit Official MySQL [Replication](https://dev.mysql.com/doc/refman/8.3/en/replication.html) guide.

1. Configure a MySQL source server
First, configure the source server by editing the MySQL configuration file. Pay close attention to ensuring the server-id value is unique.

Include the following options in the /etc/my.cnf.d/mysql-server.cnf file under the [mysqld] section:

```bash 
sudo nano /etc/my.cnf.d/mysql-server.cnf
bind-address=<source_ip_address>
log_bin=<path_to_source_server_log>
# For example, specify the log file is found along this path: log_bin=/var/log/mysql/mysql-bin.log.

server-id=<id>
# The server-id must be unique; otherwise, replication won't work it's normally 1 you can change it to a different value.set it to a unique value eg server-id=10

```

Because you made changes to the configuration file, you must restart the mysqld service:

```bash
 sudo systemctl restart mysqld.service

```

2. Configure a MySQL replica server

Now move to the replica server and edit its configuration file, again ensuring the server-id is unique.

Include the following options in the /etc/my.cnf.d/mysql-server.cnf file under the [mysqld](https://dev.mysql.com/doc/refman/8.3/en/replication-howto-slavebaseconfig.html) section (if you want to read more about the options, refer to the MySQL documentation).

```bash
sudo nano /etc/my.cnf.d/mysql-server.cnf
log_bin=<path_to_source_server_log>
#For example, the source server's log file might be here: log_bin=/var/log/mysql/mysql-bin.log.

relay-log=path_to_replica_server_log
#The replication server's log might be along this path: relay-log=/var/log/mysql/mysql-relay-bin.log.

server-id=<id>
#The server-id must be unique; otherwise, replication won't work. set it to a unique value eg server-id=21

```
You changed the configuration file on the replica server, so don't forget to restart the mysqld service:

```bash
sudo systemctl restart mysqld.service

```

3. Create a replication user on the MySQL source server

Now that the replication configuration is in place on both servers, the next step is to configure the necessary user account on the source server. Run the following commands from the MySQL command prompt.

Create a replication user:

```sql

mysql> CREATE USER 'replication_user'@'replica_server_ip' IDENTIFIED WITH mysql_native_password BY 'password';

```
Grant the user replication permissions:

```sql 

mysql> GRANT REPLICATION SLAVE ON *.* TO 'replication_user'@'replica_server_ip';

```
Reload the grant tables in the MySQL database:

```sql
mysql> FLUSH PRIVILEGES;

```
4. Obtaining the [Replication Source Binary Log Coordinates](https://dev.mysql.com/doc/refman/8.3/en/replication-howto-masterstatus.html)

Start a session on the source by connecting to it with the command-line client, and flush all tables and block write statements by executing the FLUSH TABLES WITH READ LOCK statement:

```sql
mysql> FLUSH TABLES WITH READ LOCK;

```
Leave the client from which you issued the FLUSH TABLES statement running so that the read lock remains in effect. If you exit the client, the lock is released.

In a different session on the source, use the SHOW BINARY LOG STATUS statement to determine the current binary log file name and position:

```sql
mysql> SHOW BINARY LOG STATUS\G
*************************** 1. row ***************************
             File: mysql-bin.000003
         Position: 73
     Binlog_Do_DB: test
 Binlog_Ignore_DB: manual, mysql
Executed_Gtid_Set: 3E11FA47-71CA-11E1-9E33-C80AA9429562:1-5
1 row in set (0.00 sec)
```
The File column shows the name of the log file and the Position column shows the position within the file. In this example, the binary log file is mysql-bin.000003 and the position is 73. Record these values. You need them later when you are setting up the replica. They represent the replication coordinates at which the replica should begin processing new updates from the source.

5.  Creating a Data Snapshot Using mysqldump to see more [mysqldump options](https://dev.mysql.com/doc/refman/8.3/en/mysqldump.html)

```bash
mysqldump [options] --databases db_name --source-data > dbdump.db

```
To import the data, either copy the dump file to the replica, or access the file from the source when connecting remotely to the replica. After then
In the terminal where you acquired the read lock, release the lock:
```sql

mysql> UNLOCK TABLES;

```

5. Setting Up [Replicas]()

The final piece is to connect the replica server with the source server. These steps are also conducted at the MySQL prompt on the replica server.

- Setting Up Replication with New Source and Replicas
    1. Start up the replica.

    2. Execute a CHANGE REPLICATION SOURCE TO statement on the replica to set the source configuration. 
    If you are setting up a new replication environment using the data from a different existing database server to create a new source, run the dump file generated from that server on the new source. The database updates are automatically propagated to the replicas: Go to location of dump and run

    ```bash

        $> mysql -u user -p dbname < dumpfile.db 
        #or just 
        $> mysql < fulldb.dump

    ```
    You may need to set permissions and ownership on the files so that the replica server can access and modify them. Then start the replica server, ensuring that replication does not start by using --skip-replica-start.


   ```bash
        #or sudo nano mysql.ini and set 
    sudo nano /etc/my.cnf.d/mysql-server.cnf

        skip-replica-start=ON

    $> mysqld --skip-replica-start
    
    ```

6. Setting the Source Configuration [on the Replica](https://dev.mysql.com/doc/refman/8.3/en/replication-howto-slaveinit.html)
```sql 
mysql> CHANGE REPLICATION SOURCE TO
    ->     SOURCE_HOST='source_host_name',
    ->     SOURCE_USER='replication_user_name',
    ->     SOURCE_PASSWORD='replication_password',
    ->     SOURCE_LOG_FILE='recorded_log_file_name',
    ->     SOURCE_LOG_POS=recorded_log_position;
```
Start the replica thread in the MySQL replica server:

```sql 
mysql> START REPLICA;
```
To stop or see status

```sql
mysql> STOP REPLICA;
mysql> SHOW REPLICA STATUS\G
```

# Others 
1. creating a dump using [mysqldump](https://dev.mysql.com/doc/refman/8.3/en/mysqldump.html)
```bash
mysqldump [options] db_name [tbl_name ...]
mysqldump [options] --databases db_name ...
mysqldump [options] --all-databases

mysqldump [options] --result-file=dump.sql
```