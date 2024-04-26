## LARAVEL DOCKER SET UP

***Prerequisites***
DOCKER CMDS

```bash
#run or install an image it-Interactive terminal
COPY
WORKDIR
FROM
RUN
CMD
#OPTIONS 
'
-it : interactive terminal
-p: map a port # 80:8000
-q : Stopped images 
-t : Give a tag to an image 
'
docker run -it image_name

#remove an image 
docker rmi $(docker images -q)

```
ROADMAP STEPS

```bash
#create the services folder eg php inside 
#CREATE A DOCKERFILE : it's a file used for an image configuration.
#Grab your base image 
FROM ubuntu

RUN apt update 

RUN apt install package -y #yes flag to requests EG apt install nginx -y

CMD service packackage start && other commands && and another

#or create the services folder eg php inside 
#CREATE A DOCKERFILE : it's a file used for an image configuration.
FROM php8.2

RUN apt update 
```
[See example of a PHP Dockerfile](https://hub.docker.com/_/php)

DOCKER COMPOSE:
Bring together all the files 
```bash

define your services
```

OTHER TIPS
```bash
#enter interactive mode
docker exec -it container_name bash

docker compose up -d #detach mode
docker compose down

docker ps -a

docker logs container_name #check a container logs

docker images # see list of docker images

docker rmi $(docker images -q) -f #force remove images

docker build -t tag_name /path/to/Dockerfile #build an image from a docker file
#eg docker build -t php php
docker run -it php bash #run the image in interactive mode bash
#remove an image

docker rmi php -f 

docker inspect networks


```
NOTES

Volumes helps to persist data
uding COPY command will copy the contents
when you map volumes in the composer file it overwrites any copies done during the image defination stage