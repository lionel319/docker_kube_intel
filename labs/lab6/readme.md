# Lab 6A : Tagging and Pushing images

1. In this lab you will tag container images and push to registry 
    >> You need a DockerHub or Quay.io account 

2. Login to your Container Registry 
    ```
    docker login 
    Username: XXXXXX
    Password: XXXXXX

    Login Succeeded

    ```

3. Tag your local images 
    ```
    docker images 

    docker tag (new container image name):latest  (dockerhub_alias)/(new_name):(tag)

    # example:  docker tag inteldemoapp:latest  stv707/inteldemoapp:latest
    
    ```
    >> stv707/(image name):(version) is a sample repo followed by container name and version 

4. A tag matches your registry required to push the image to a registry 
    ```
    docker push stv707/inteldemoapp:latest 
    
    ```

5. Verify the image has been pushed to Docker Hub by visiting Docker Hub

# END