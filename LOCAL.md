## LOCAL VIRTUAL CONFIGS
Want to set up a local domain for your Application create a virtual config file and for the sernname name and alias put your alias 
```bash
<VirtualHost *:80>
     ServerAdmin admin@app
     ServerName app.local
     ServerAlias www.app.local
    #continue with the relevant configs
```

- Now to enable you site to be reachable locally you have to link your localhost ip with the url(link) the file `/etc/hosts`

```bash
    #include your name binding 
    # for localhost 
    127.0.0.1 app.local
    127.0.0.1 www.app.local
 
```
