
# Getting started with DOCKER 
Docker is a very powrful tool in devops for Containerization and microservices . It reproduces environments solving problems of depedencies.
The developer sets the environment in the docker file and any other person can just build the 
- Dockerfile : blueprint for building a docker image
- Docker image : Template for runing docker containers
        - images can be pushed to docker hub made public or private fo use by anyone
- Container: A running Process

## Setting up on Linux

See [Basic requirements](https://docs.docker.com/desktop/install/linux-install/#system-requirements) for Linux platforms.

For non-Gnome Desktop environments, gnome-terminal must be installed:

```bash
sudo apt install gnome-terminal

```
    1. install Docker desktop

Installation methods

You can install Docker Engine in different ways, depending on your needs:
 
1. Docker Engine comes bundled with [Docker Desktop for Linux](https://docs.docker.com/desktop/install/linux-install/) . This is the easiest and quickest way to get started.

However here I faced the issues **Can't install docker desktop - docker-desktop : Depends: docker-ce-cli but it is not installable**
 
 **Solution** : I first added the repositories  in Step 1 for APT below then run the DEB file

2. Set up and install Docker Engine from [Docker's apt repository](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository).

### STEP 1 Set up Docker's apt repository.
```bash

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources: If in mint Replace the version code If you use an Ubuntu derivative distro, such as Linux Mint, you may need to use UBUNTU_CODENAME instead of VERSION_CODENAME.
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

#like
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "jammy") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

#INCASE YO ACCIDENTALLY ADD THE WRONG REPO AND NEED TO REMOVE AND ADD IT AFRESH DO 
sudo rm /etc/apt/sources.list.d/docker.list

```
## INSTALL DOCKER PACKAGES

```bash
sudo apt-get update

# STEP 2 Install the Docker packages. Or now Install the deb you downloaded.

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

```
3. To allow you to sign in to docker desktop 

You can initialize pass by using a gpg key. To generate a gpg key, run:

```bash
gpg --generate-key
#follow the prompts then 

pass init <your_generated_gpg-id_public_key> #replace twith your generated key

```

