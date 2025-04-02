## COMMON LINUX COMMANDS
### DISK USAGE
```bash
# df: This is the command for "disk free.
#:du This is the command for "disk usage."
#-s: This option stands for "summarize" and gives you a total for the specified directory.
#-h: This option stands for "human-readable" and makes the output easier to read for humans 
#.: This specifies the current directory.
#
#space
df -h
#current directory usage 
du -sh .
# file sizes in a folder listing
du -sh *
# output the content of a particular line in a big file that cannot be opened normally for instance line 6574 of an over 20gb sql file
sed -n '6574p'filename.sql

```

###  MYSQL IMPORTS 

```bash 

#to dump a database 
    mysqldump -u dbuser -p db_name > dump_file.sql
# dump sereval dbs

mysqldump --databases db_name1 [db_name2 ...] > my_databases.sql

# dump all 
mysqldump --all-databases > all_databases.sql

# to import into a database To load the dump file back into the server:

    mysql -u dbuser -p db_name < file.sql

#ALL OPTIONS
mysqldump [options] db_name [tbl_name ...]
mysqldump [options] --databases db_name ...
mysqldump [options] --all-databases
```
for more dumping details [see details](https://dev.mysql.com/doc/refman/8.4/en/mysqldump.html)

