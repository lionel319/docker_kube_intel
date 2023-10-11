# Lab 3A : Using docker bind-mount 

1. pull httpd docker image
    ```
    docker pull httpd

    docker images 
    ```

2. Create a dir and index.html file to overwrite container supplied index.html via bind-mount :
    ```
    cd ~

    mkdir httpdata

    vim httpdata/index.html

    <html>
        <body>
        <h2> Hello, welcome to stu001 apache web server </h2>
        </body>
    </html>

    * save the file and exit vim 

    ```

3. Deploy a container with bind mount: 
    ```
    docker run -d -p 7373:80 --name myhttpd -v ~/httpdata:/usr/local/apache2/htdocs/ httpd:latest
    ```

4. Confirm the bind-mount 
    ```
    docker inspect myhttpd | grep Mounts -A 9
    ```

5. Open a web browser and browse to http://**PUBLIC IP**:7373

6. Add/Update the content of index.html  
    ```
    cd ~ 

    vim httpdata/index.html

    <p> Adding new data to index.html </p>

    * Save and exit vim 
    ```

7. Refresh http://**PUBLIC IP**:7373 in browser and verify new content


# Lab 3B : Using docker volume

1. Create a docker volume 
    ```
    docker volume ls

    docker volume create webdata
    ```

2. run a new container using the volume 
    ```
    docker run -d -p 7474:80 --name myweb2 -v webdata:/usr/local/apache2/htdocs/  httpd:latest
    
    curl http://localhost:7474

    ```

3. Copy index.html into myweb2 container's /usr/local/apache2/htdocs/
    ```
    docker cp httpdata/index.html  myweb2:/usr/local/apache2/htdocs/

    curl http://localhost:7474
    
    ```

4. create another container using the same volume 
    ```
    docker run -d -p 7575:80 --name myweb3 -v webdata:/usr/local/apache2/htdocs/  httpd:latest

    curl http://localhost:7575

    ```
    >>container myweb2 and myweb3 are using the same volume (webdata)

5. Stop myweb2 and myweb3 container and permanently remove the container 
    ```
    docker stop myweb2 myweb3

    docker rm -f myweb2 myweb3
    ```

6. Verify docker container myweb2 and myweb3 are no more in the listing
    ```
    docker ps -a 
    ```

7. Verify volume webdata still exist and explore the data
    ```
    docker volume ls

    docker inspect webdata

    sudo ls -l /var/lib/docker/volumes/webdata/_data

    sudo cat /var/lib/docker/volumes/webdata/_data/index.html
    ```

8. Start a new container with the volume webdata
    ```
    docker run -d -p 8181:80 --name mynewweb -v webdata:/usr/local/apache2/htdocs/  httpd:latest

    curl http://localhost:8181
    ```

9. Edit the volume file (index.html)
    ```
    sudo vim /var/lib/docker/volumes/webdata/_data/index.html

    <p> Container data in Volume </p>

    *save and exit the file 
    ```

10. curl and verify the changes 
    ```
    curl http://localhost:8181
    ```
    >>As long the volume is not deleted, your data will be inside the volume


# END