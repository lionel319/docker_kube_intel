# Lab 4A : Using docker network

1. Create docker network for database backend
    ```
    docker network create dbnet

    docker network ls
    ```

2. Create docker network for frontend app 
    ```
    docker network create appnet

    docker network ls
    ```

3. Deploy database backend attached to dbnet: 
   **Make sure to stop and remove any other docker containers from previous labs** 
    ```
    docker run -d -p 3306:3306 --name mysqldb -e MYSQL_ROOT_PASSWORD=password -e MYSQL_DATABASE=todo --network=dbnet mysql:5.7
    ```

4. Verify mysqldb container have *todo* database 
    ```
    docker exec mysqldb mysql -uroot -ppassword -e 'show databases'
    ```

5. Pull and Deploy backend app attached to dbnet and appnet
    ```
    docker pull stv707/todobackend:v1
    
    docker images 

    docker run -d -p 3000:3000 --name backendapp -e DATABASE_SVC=mysqldb -e DATABASE_PASSWORD=password --network=dbnet  stv707/todobackend:v1
    ```

6. Curl the backendapp container to verify runtime
    ```
    curl http://localhost:3000
    ```
    >> you should receive OK (otherwise get up from your chair and do 5 set of jumping jack and contact Steven)

7. Connect backendapp container to appnet docker network 
    ```
    docker network connect appnet backendapp
    ```

8. Verify the backendapp container connected to appnet and dbnet 
    ```
    docker inspect backendapp  | grep "Networks" -A 100
    ```

9. Deploy frontend app container attached to appnet network
    ```
    docker pull stv707/todofrontend:v2

    docker run -d -p 8080:8080 --name frontendapp --network=appnet stv707/todofrontend:v2

    ```

10. Open a web browser and browse to http://**PUBLIC IP**:8080 
    >> Verify you can see and add task to To Do list Web Application 


11. Verify Network Connection of the Containers 
    ```
    docker inspect mysqldb  | grep Networks -A 100
    ```
    >> mysqldb should be connected to dbnet 

    ```
    docker inspect backendapp  | grep Networks -A 100
    ```
    >> backendapp should be connected to dbnet and appnet 

    ```
    docker inspect frontendapp  | grep Networks -A 100
    ```
    >> frontendapp should be connected to appnet 


12. The entire deployment should resemble the below ascii diagram
    ```bash
    frontend ---> (appnet) <---> backendapp <---> (dbnet) ---> mysqldb 

    ```

# Clean all containers before moving to Lab 4B
    ```
    docker rm -f frontendapp backendapp mysqldb
    ```

# Lab 4B : Using docker network (DNS Round Robin Example)

1. Create docker network called rrnet 
    ```
    docker network create rrnet

    docker network ls 
    ```

2. pull elasticsearch:2 and curl container image 
    ```
    docker pull elasticsearch:2 

    docker pull curlimages/curl

    docker images 
    
    ```

3. create containers that attached to rrnet 
    ```
    docker run -d --name search1  --network rrnet --net-alias search elasticsearch:2

    docker run -d --name search2  --network rrnet --net-alias search elasticsearch:2

    ```

4. curl the elasticsearch to very round robin 
    ```
    docker run -it --rm --name ubi7 --network rrnet centos:7 bash 

    $ curl http://search:9200 
    ```
    >> rerun the curl command to confirm its hitting both search1 and search2 containers 

# END