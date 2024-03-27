1. Configure a MySQL source server
First, configure the source server by editing the MySQL configuration file. Pay close attention to ensuring the server-id value is unique.

Include the following options in the /etc/my.cnf.d/mysql-server.cnf file under the [mysqld] section:

bind-address=<source_ip_address>
log_bin=<path_to_source_server_log>
For example, specify the log file is found along this path: log_bin=/var/log/mysql/mysql-bin.log.

server-id=<id>
The server-id must be unique; otherwise, replication won't work.

gtid_mode=ON
enforce-gtid-consistency=ON
Because you made changes to the configuration file, you must restart the mysqld service:

$ sudo systemctl restart mysqld.service
2. Configure a MySQL replica server
Now move to the replica server and edit its configuration file, again ensuring the server-id is unique.

Include the following options in the /etc/my.cnf.d/mysql-server.cnf file under the [mysqld] section (if you want to read more about the options, refer to the MySQL documentation).

log_bin=<path_to_source_server_log>
For example, the source server's log file might be here: log_bin=/var/log/mysql/mysql-bin.log.

relay-log=path_to_replica_server_log
The replication server's log might be along this path: relay-log=/var/log/mysql/mysql-relay-bin.log.

server-id=<id>
The server-id must be unique; otherwise, replication won't work.

gtid_mode=ON
enforce-gtid-consistency=ON
log-replica-updates=ON
skip-replica-start=ON
You changed the configuration file on the replica server, so don't forget to restart the mysqld service:

$ sudo systemctl restart mysqld.service
Skip to the bottom of list
Image
IT Automation ebook
3. Create a replication user on the MySQL source server
Now that the replication configuration is in place on both servers, the next step is to configure the necessary user account on the source server. Run the following commands from the MySQL command prompt.

Create a replication user:

mysql> CREATE USER 'replication_user'@'replica_server_ip' IDENTIFIED WITH mysql_native_password BY 'password';
Grant the user replication permissions:

mysql> GRANT REPLICATION SLAVE ON *.* TO 'replication_user'@'replica_server_ip';
Reload the grant tables in the MySQL database:

mysql> FLUSH PRIVILEGES;
Set the source server to the read_only state:

mysql> SET @@GLOBAL.read_only = ON;
4. Connect the replica server to the source server
The final piece is to connect the replica server with the source server. These steps are also conducted at the MySQL prompt on the replica server.

Set the replica server to the read_only state:

mysql> SET @@GLOBAL.read_only = ON;
Configure the replication source:

mysql> CHANGE REPLICATION SOURCE TO
    -> SOURCE_HOST='source_ip_address',
    -> SOURCE_USER='replication_user',
    -> SOURCE_PASSWORD='password',
    -> SOURCE_AUTO_POSITION=1;
Start the replica thread in the MySQL replica server:

mysql> START REPLICA;
Now unset the read_only state on both servers, and you can make changes to the source server. These changes are sent to the replica:

mysql> SET @@GLOBAL.read_only = OFF;