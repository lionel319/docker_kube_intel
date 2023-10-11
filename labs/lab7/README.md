#  Lab 7 - Pods 

# Step 1 
Create and Verify Single Container Pod 

```sh
 kubectl create -f kubia-pod.yaml
 
 kubectl get po kubia-pod -o yaml
 
 kubectl get po kubia-pod -o json
 
 kubectl get pods

 kubectl get pods -o wide

 kubectl create -f box1.yaml

 kubectl create -f box2.yaml

 kubectl get pods -o wide
```

# Step 2 
Create and Verify Multi Container Pod ( init container )

```sh
kubectl create -f kubia-pod-init-multi.yaml

kubectl get pod kubia-pod-init -w
**As per kubia-pod-init-multi.yaml manifest, init container runs sleep command for 90 second, after 90 Second, the main container will start
```

# Step 3 
Create and Verify Multi Container Pod ( sidecar container )

```sh
kubectl create -f kubia-pod-sidecar-multi.yaml

kubectl get pod
** Note from output there is 2/2 in READY state for sidecar-container-demo

kubectl get pod -o wide
** NOTE the IP address of sidecar-container-demo 

kubectl exec -it box1 -- sh 
# curl IP_sidecar-container-demo 
# exit 

kubectl delete -f kubia-pod-sidecar-multi.yaml
```

# Step 4 
Inter-Pod Networking  

```sh

kubectl get pod -o wide 

** Note the IP address of kubia-pod 
** Open another terminal(Azure Cloud Shell) to perform next step 

kubectl exec -it box1 -- sh 
# curl http://IP_kubia_pod:8080
# exit 

kubectl exec -it box2 -- sh 
# curl http://IP_kubia_pod:8080
# exit 

```

# Delete/Remove pods

```sh

** Delete all pod to prepare for next lab

```


# END