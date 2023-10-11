# Lab 1A : Install Docker

1. update your existing list of packages:
    ```
    sudo apt update
    ```

2. Next, install a few prerequisite packages which let apt use packages over HTTPS:
    ```
    sudo apt install apt-transport-https ca-certificates curl software-properties-common
    ```

3. Then add the GPG key for the official Docker repository to your system:
    ```
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    ```

4. Add the Docker repository to APT sources:
    ```
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
    ```

5. Make sure you are about to install from the Docker repo instead of the default Ubuntu repo:
    ```
    apt-cache policy docker-ce
    ```

6. install Docker
    ```
    sudo apt install docker-ce
    ```

7. Docker should now be installed, the daemon started, and the process enabled to start on boot.
    ```
    sudo systemctl status docker
    ```

8. Add your username to the docker group:
    ```
    sudo usermod -aG docker ${USER}
    ```

9. To apply the new group membership, log out of the server and back in

10. Verify your user account is member of docker group
    ```
    groups 
    ```

11. run docker command and verify the installation 
    ```
    docker info

    docker ps 

    docker images 

    docker network ls 

    docker volume ls

    docker version 
    ```
# Lab 1B : Install Nginx Proxy

1. Update the local package index so that we have access to the most recent package listings. Afterwards, we can install nginx:
    ```
    sudo apt update
    sudo apt install nginx
    ```

2. We can check with the systemd init system to make sure the service is running by typing
    ```
    systemctl status nginx
    ```

3. Curl the localhost for Nginx Welcome Page
    ```
    curl localhost | grep -i nginx
    ```

4. Update the default nginx page
    ```
    sudo vim /var/www/html/index.nginx-debian.html

    <title>Welcome to stuXXX! Default O.S Nginx</title>

    <h1>Welcome to stuXXX! Default O.S Nginx</h1>
    
    * Save the file

    ```
    >>Replace the stuXXX with your assigned student name

# Lab 1C : Test DNS

1. All the labs VM and Setup has DNS records. A child domain under ``trainocate.cloud`` have been created for each system. 

2. The following is the dns setup entries:

    |Child Domain | Application |  Kubernetes |
    |--|--|--|
    | stuXXX.trainocate.cloud  | appX.stuXXX.trainocate.cloud  |  kubX.stuXXX.trainocate.cloud |

    >> stuXXX represents stu001, stu002...stu008

    >> appX represents app1, app2...app9

    >> kubX represents kub1, kub2...kub9

3. Using your assigned stuXXX (please refer to Steven if you are not sure), run a dig command to verify dns entries 

    ```
    dig NS  stuXXX.trainocate.cloud
    ```
    >> the status should return **NOERROR**

    ```
    dig app1.stuXXX.trainocate.cloud
    ```
    >> a A record should return 

4. Verify access to Nginx Proxy using web browser via fqdn: 

    - use chrome/firefox to browse to http://**PUBLIC IP**
    - you should receive Modified Nginx welcome page


# Lab 1D : Deploy Sample Docker Container and Configure Nginx Reverse Proxy

1. Use the following command to deploy a sample docker container 
    ```
    docker pull stv707/hello-intel

    docker run -d --name intelone -p 8080:8080 -e RESPONSE="Hello from YOUR_NAME"  stv707/hello-intel:latest
    ```

2. Verify the docker container is running and accessible 
    ```
    docker ps 

    curl localhost:8080 
    ```
    >> You should receive the response you give from step 1

3. Edit the sample **app1.stuXXX.trainocate.cloud** file
    ```
    vim app1.stuXXX.trainocate.cloud    
    ```
    >> find the entry ``server_name app1.stuXXX.trainocate.cloud`` and change the ``stuXXX`` to your **assigned number**

4. Copy the config file to nginx virtual host 
    ```
    sudo cp app1.stuXXX.trainocate.cloud   /etc/nginx/sites-available/app1.stu001.trainocate.cloud
    ``` 
    >> the ``app1.stu001.trainocate.cloud`` is just a sample for the command, please use your **assigned number!!** 


    ```
    sudo ln -s /etc/nginx/sites-available/app1.stu001.trainocate.cloud  /etc/nginx/sites-enabled/app1.stu001.trainocate.cloud
    ```
    >> Again, the stu001 in app1.stu001.trainocate.cloud is just a sample for the command, please use your **assigned number!!**

5. Restart the nginx service
    ```
    sudo systemctl restart nginx.service
    ```

6. Browse **app1.stu001.trainocate.cloud** from a web browser to verify you can access the Docker Container

# END