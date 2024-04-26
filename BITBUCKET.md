## BITBUCKET SET UP

***Prerequisites***
CREATING REPO
Create A Workspace. Then create a repository
```bash
#copy the repository link
git init #in your local project 
git add .
git commit -m "message"
git remote -v
git remote add origin #linkhere
git branch -vv
git push -u -f origin master #u flag help to track the remote master branch -f force update

```
PIPELINES
An integrated CI/CD integration service
```bash
#create the pipeline using the starter template.
PIPELINES USE DOCKER IMAGES TO CREATE OUR TEST ENVIRONMENT PLATFOMS
git pull # to get changes .
#Edit local copy
#CREATE A DEVOPS FOLDER AND CREATE A BASH SCRIPT FOR SETTING UP THE TEST ENVIRONMENT SERVER

```
iNSIDE THE PIPELINE yaml FILE for scripts indicate the path to your script

```