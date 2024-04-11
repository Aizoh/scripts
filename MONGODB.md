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
