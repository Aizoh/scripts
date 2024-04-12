## Mongo DB for LInux installation
 URL portion of this command to align with the version you want to install:

1. **Prerequisites**
```bash
#Add source
#curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | sudo apt-key add -
wget -qO - https://www.mongodb.org/static/pgp/server-7.0.asc | sudo gpg --dearmor -o /usr/share/keyrings/mongodb-archive-keyring.gpg

#Output OK

#check if its added 

apt-key list

```
configure APT source lists

```bash

#find a source for your linux distribution
#to remove a wog source 
sudo rm /etc/apt/sources.list.d/mongodb-org-7.0.list

#echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu dists/jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

#then 
sudo apt update

```
Following that, you can install MongoDB:

```bash
sudo apt install mongodb-org

```
2. **Creating, Testing MongoDB service and Database**
Start Mongo DB Service
```bash
sudo systemctl start mongod.service
#check status
sudo systemctl status mongod
```
Enable start at boot 

```bash
sudo systemctl enable mongod

```
3. **Other commands**

Other relevant MongoService Management commands 

```bash
#verify that the database is operational by connecting to the database server and executing a diagnostic command. 
mongo --eval 'db.runCommand({ connectionStatus: 1 })'

#STOP SERVICE
sudo systemctl stop mongod

#START SERVICE
sudo systemctl start mongod

#RESTART SERVICE
sudo systemctl restart mongod

#DISABLE AUTOMATIC START UP ON BOOT
sudo systemctl disable mongod

#RE-ENABLE STARTUP ON BOOT
sudo systemctl enable mongod

```
## Laravel MOngo
[See Example](https://www.mongodb.com/compatibility/mongodb-laravel-integration)
install the PHP extension for MongoDB. Run the following command:

```bash

sudo apt update
sudo apt install -y php-pear php-dev libssl-dev

sudo apt install -y php-pear
sudo pecl channel-update pecl.php.net
sudo pecl install mongodb

#Add the following line to your php.ini file for cli and fpm:
extension="mongodb.so"

#restart your server

sudo systemctl restart apache2

```
Add to your laravel project
```bash

composer require mongodb/laravel-mongodb

```
To access an instance of a running mongo service 

```bash

mongosh

#To display the database you are using, type db:

db
#To switch databases, issue the use <db> helper, as in the following example:
use <database>

#Create a New Database and Collection Collections are like tables
use myNewDatabase
#db.movies; optional

#insert data
use myNewDatabase

db.movies.insertOne(
  {
    title: "The Favourite",
    genres: [ "Drama", "History" ],
    runtime: 121,
    rated: "R",
    year: 2018,
    directors: [ "Yorgos Lanthimos" ],
    cast: [ "Olivia Colman", "Emma Stone", "Rachel Weisz" ],
    type: "movie"
  }
)
```

**Get connection string**
```bash
db.getMongo()


```
```php
//The following connects and logs in to the admin database as user myDatabaseUser with the password D1fficultP%40ssw0rd:

mongodb://myDatabaseUser:D1fficultP%40ssw0rd@localhost

//create a universal user for your mongo db 
#in terminal 
mongosh
use admin

db.createUser({
    user: "<username>",
    pwd: "<password>",
    roles: [
        { role: "readWriteAnyDatabase", db: "admin" },
        { role: "userAdminAnyDatabase", db: "admin" },
        { role: "dbAdminAnyDatabase", db: "admin" },
        { role: "clusterAdmin", db: "admin" }
    ]
})
//Authenticate the user

db.auth("<username>", "<password>")

```
**[MORE MONGO DB METHODS](https://www.mongodb.com/docs/manual/reference/method/)***
**[LARAVEL MONGODB](https://www.mongodb.com/docs/drivers/php/laravel-mongodb/current/quick-start/download-and-install/)**
**[LARAVEL MONGODB GETTING STARTED GUIDE](https://www.mongodb.com/docs/drivers/php/laravel-mongodb/current/)**
