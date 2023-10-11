# Lab9A

# Step
Create Service and Test the Service

```sh
kubectl create -f kubia-svc.yaml
kubectl create -f kubia.yaml
kubectl create -f jump_tool_pod.yaml 

kubectl get svc
kubectl get pods -o wide
*note the IP address of each pod

kubectl exec -it jump1 -- sh 

# curl <ip_kubia-xxxx_pod>:8080
# curl <ip_kubia_service>
# curl kubia 
# exit 

kubectl create -f kubia-api-svc.yaml

kubectl get svc  -o wide
*note the IP address of kubia-api ClusterIP  IP

kubectl exec -it jump1 -- sh 

# curl kubia-api
# curl <ip_kubia_api_service>

# exit 

```

# Lab9B

# Step
Create LoadBalancer Service and Test the Service
```sh
kubectl create -f kubia-svc-loadbalancer.yaml

kubectl get svc
*The external IP of LoadBalancer type may show pending, rerun kubectl get svc after few minutes

curl http://<External_IP>
```

## Before moving to next step, you need to remove/delete LoadBalancer Service, because Digital Ocean only allows 1 PIP
```sh
kubectl  get svc

kubectl delete -f kubia-svc-loadbalancer.yaml

kubectl delete -f kubia.yaml

kubectl delete -f kubia-svc.yaml

# Very important step!! 
```

# Lab9C
# Step 1 - Setting Up 2 Hello World Deployments

```sh

# You may update the env MESSAGE to suit yourself 
kubectl create -f hello-kubernetes-first.yaml

# You may update the env MESSAGE to suit yourself 
kubectl create -f hello-kubernetes-second.yaml

kubectl get svc 

kubectl get pods 
```

# Step 2 — Installing the Kubernetes Nginx Ingress Controller
Now you’ll install the Kubernetes-maintained Nginx Ingress Controller using Helm.

The Nginx Ingress Controller consists of a Pod and a Service. The Pod runs the Controller, which constantly polls the /ingresses endpoint on the API server of your cluster for updates to available Ingress Resources. The Service is of type LoadBalancer. Because you are deploying it to a DigitalOcean Kubernetes cluster, the cluster will automatically create a DigitalOcean Load Balancer through which all external traffic will flow to the Controller. The Controller will then route the traffic to appropriate Services, as defined in the Ingress Resources.

Only the LoadBalancer Service knows the IP address of the automatically created Load Balancer. Some apps (such as ExternalDNS) will need to know its IP address but can only read the configuration of an Ingress. The Controller can be configured to publish the IP address on each Ingress by setting the controller.publishService.enabled parameter to true during helm install. It is recommended to enable this setting to support applications that may depend on the IP address of the Load Balancer.

>> We will learn helm in upcoming chapter. Don't worry about it for now!

```sh
sudo snap install helm --classic

chmod 600 /home/${USER}/.kube/config

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

helm repo update

helm install nginx-ingress ingress-nginx/ingress-nginx --set controller.publishService.enabled=true

kubectl --namespace default get services -o wide -w nginx-ingress-ingress-nginx-controller
# Once you receive the PIP, please update your assigned name (stuXXX) with your ingress PIP to Steven 
# -w means watch, you need to control+c to stop the watch once you receive the PIP. 
```

# Step 3 — Exposing the App Using an Ingress
* Edit the hello-kubernetes-ingress.yaml and add your dns entry 
* Change this entry : - host: kub1.stuXXX.traninocate.cloud to your assigned stu number.
* Change this entry : - host: kub2.stuXXX.traninocate.cloud to your assigned stu number

# Step 4 - Create the ingress for hello-kubernetes-first and hello-kubernetes-second
```sh 
kubectl apply -f hello-kubernetes-ingress.yaml
kubectl get ingress 
```
>> ignore: Warning: annotation "kubernetes.io/ingress.class" is deprecated, please use 'spec.ingressClassName' instead


# Step 5 - Access the application using domain name 
* browse to http://kub1.stuXXX.trainocate.cloud and http://kub2.stuXXX.trainocate.cloud

END