# Lab 13A : Install container application using helm

1. Add 'wordpress' helm repo
    ```
    helm list 
    
    helm repo list

    helm repo add bitnami https://charts.bitnami.com/bitnami
    ```

2. Verify the repo
    ```
    helm list

    helm repo list
    ```

# **This is critical!! as we are using ingress**
3. Change ingress host value in **values-wordpress.yaml** to your assigned domain name ( kub7.stuXXX.trainocate.cloud )
    ```bash
    vim values-wordpress.yaml 
    # go to line 615
    ```
    

4. install the helm chart
    ```
    helm install my-wordpress -f values-wordpress.yaml oci://registry-1.docker.io/bitnamicharts/wordpress

    helm list 

    helm status my-wordpress

    ```

5. the helm install will deploy and configure:
    - deployment : my-wordpress
    - pv and pvc for wordpress and mariadb
    - statefulset for mariadb 
    - wordpress network ingress
    - wordpress network service 
    - configmap : my-wordpress-mariadb
    - secret : my-wordpress-mariadb & my-wordpress


6. Verify all the Kubernetes Resources
    ```
    kubectl  get  pod  | grep wordpress

    kubectl get deployments.apps | grep wordpress

    kubectl get pv

    kubectl get pvc

    kubectl get service  | grep wordpress

    kubectl get ingress

    kubectl get cm 

    kubectl get secret 
    
    ```


7. If everythings goes good, you should able to browse to http://kub7.stuXXX.trainocate.cloud to access Wordpress 


8. Uninstall the helm release
    ```
    helm list

    helm uninstall my-wordpress
    ```

# END