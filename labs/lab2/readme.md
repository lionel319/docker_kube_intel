# Lab 2A : Deploy Container

1. verify docker version and installation
    ```
    docker info 

    docker version 
    ```

2. Run hello world :
    ```
    docker run hello-world

    docker container run hello-world

    docker images

    ```

3. Deploy a container and verify access:
    ```
    docker run -p 7070:80 nginx
    ```

4. Open another terminal and verify access :
    ```
    curl localhost:7070
    ```

5. Back to main terminal and end the running container by control+c 

6. Verify all previous and running containers 
    ```
    docker ps

    docker ps -a 
    ```

7. Deploy a container with name and run it in detached mode.
    ```
    docker run -p 7171:80 -d --name mywebhost nginx

    docker ps
    ```

8. Browse to your public address (open Web Browser and browse to http://**PUBLIC UP**:7171) 

9. Open a new terminal and run the following to follow logs of Container
    ```
    docker logs mywebhost -f
    ```
    >> While you monitor the logs of container mywebhost, access the container by using curl or web browser as step 8

10. Control+c to stop log following 

11. run docker top command to examine the process running inside the container 
    ```
    docker top mywebhost
    ```

12. run docker stat to examine the CPU/MEM/IO/Network usage
    ```
    docker stats mywebhost
    ```
    >>control+c to stop monitoring 

13. Inspect the container details to get detailed information of running container
    ```
    docker inspect mywebhost 
    ```

14. get a shell inside the running container 
    ```
    docker exec -it mywebhost bash
    ```

15. while inside the running container, install vim and modify the default index page 
    ```
    apt-get update

    apt-get install vim

    vim /usr/share/nginx/html/index.html

    ** update the following ** 

    <h1>Welcome to nginx! Running on Container - stuXXX </h1>
    
    **Save the file 

    exit 

    ```

16. Verify the changes by browsing to http://**PUBLIC IP**:7171  


17. Clean up 
    ```
    docker ps 

    docker ps -a 
    
    docker stop <container>

    docker rm -f <container>
    ```
    >> Check the status from ``docker ps -a``, stop any running container and remove them using ``docker rm -f`` 


# Lab 2B : Deploy Multi Container and setup nginx reverse proxy to access 

1. use docker pull to pull redis 
    ```
    docker pull redis
    ```

2. use docker pull to pull stv707/voteapp:v1
    ```
    docker pull stv707/voteapp:v1
    ```

3. use docker images to verify you have both redis:latest and stv707/voteapp:v1 
    ```
    docker images
    ```

5. create docker network for internal name resolving
    ```
    docker network create votenet

    docker network ls
    ```

4. run the redis container with specific name and pass environment variables 
    ```
    docker run -d -p 6379:6379 -e ALLOW_EMPTY_PASSWORD=yes --name voteapp-backend --network=votenet  redis:latest

    docker ps -a 
    ```

5. run the frontend app (voteapp-frontend) with specific name and environment variables
    ```
    docker run -d -p 7272:80 -e REDIS=voteapp-backend --name voteapp-frontend --network=votenet  stv707/voteapp:v1

    docker ps 
    ```

6. Copy the app2.stuXXX.trainocate.cloud file to nginx sites-available 
    ```
    sudo cp app2.stuXXX.trainocate.cloud  /etc/nginx/sites-available/app2.stu001.trainocate.cloud
    ```
    >>stu001 in the previous is just an example. Use your assigned name

7. edit the app2.stuXXX.trainocate.cloud 
    ```
    vim /etc/nginx/sites-available/app2.stu001.trainocate.cloud

    server_name app2.stuXXX.trainocate.cloud
    ```
    >> change the stuXXX to reflect your assigned name

8. Link the nginx config file and restart the nginx server 
    ```
    cd /etc/nginx/sites-enabled/

    sudo ln -s /etc/nginx/sites-available/app2.stu001.trainocate.cloud app2.stu001.trainocate.cloud
    
    sudo systemctl restart nginx
    ```

9. open web browser and verify access to multicontainer  ( http://app2.stuXXX.trainocate.cloud)

10. Clean up (optional)
    ```
    docker ps -a 
    docker stop <container_name>
    docker rm -f <container_name>
    ```
    >> this is optional step to free up resources. 

# END