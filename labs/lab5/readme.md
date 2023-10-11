# Lab 5A : Build Image from Dockerfile

1. In this lab you will build 3 container images

 - you will examine the lab5/todo-backend Dockerfile
    ```
    cd ~/docker_kube_intel/labs/lab5/todo-backend

    cat Dockerfile  
    ```

2. Build a new todo-backend image based on the Dockerfile
    ```
    docker build -t todo-backend .
    ```
    >> it will take 50 - 60 second to build     

3. verify the build 
    ```
    docker images 
    ```

4. You will examine the lab5/todo-frontend Dockerfile 
    ```
    cd ~/docker_kube_intel/labs/lab5/todo-frontend

    cat Dockerfile 
    ```

5. Pull todo-frontend image (this build will take time and Hardware Spec is not enough for this build)
    ```
    docker pull stv707/todofrontend:v2
    ```
    >> the build may take long time due to hardware spec of the VM 

    >> you pull a ready-made image: `docker pull stv707/todofrontend:v2`


# Lab 5B : Create nodejs application and create a container image for the application

1. create a dir and init as nodejs application directory 
    `````
    mkdir ~/app5 

    cd ~/app5 

    npm init -y

    npm install express

    vim app.js 
    `````
    ```js
         const express = require('express');
         const app = express();
         const PORT = 7076;

         app.get('/', (req, res) => {
         res.send(`Hello, welcome to ${require('os').hostname()}`);
          });

         app.listen(PORT, () => {
         console.log(`Server is running on port ${PORT}`);
          });

    ```
    `````    
    * save and close the file 
    `````

2. Create a Dockerfile and add the following content 
    `````
    vim Dockerfile 
    `````
    ```js
    # Use the official Node.js image as the base image
    FROM node:14

    # Set the working directory in the container
    WORKDIR /usr/src/app

    # Copy package.json and package-lock.json to the working directory
    COPY package*.json ./

    # Install the application's dependencies
    RUN npm install

    # Copy the rest of the application code to the working directory
    COPY . .

    # Expose port 7076 to the outside world
    EXPOSE 7076

    # Command to run the application
    CMD ["node", "app.js"]

    ```
    `````
    save and close the file 
    `````

3. Build a docker container from Dockerfile 
    ```
    docker build -t my-node-app .

    ```

4. run the container and verify the application 
    ```
    docker run -d -p 7076:7076 --name mynodeapp my-node-app
    
    curl http://localhost:7076
    ```

# END