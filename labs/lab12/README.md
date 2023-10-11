# Lab12A
# Step 
Using Deployments for updating apps declaratively <br>
Open up 2 terminal connection to Linx <br>

Perform these steps on terminal 1 <br>
```sh

cat kubia-deployment-and-service-v1.yaml

kubectl create -f kubia-deployment-and-service-v1.yaml --record
 # Be sure to include the --record command-line option when creating it.
 # This records the command in the revision history, which will be useful later.
 # you can ignore the warning of deprecated 

kubectl get svc kubia

kubectl get deployment kubia

kubectl describe deployment kubia

kubectl rollout status deployment kubia

kubectl rollout history deployment kubia

kubectl get pod

kubectl get replicasets
```

Perform these steps on terminal 2 <br>
we will use a jump Pod to perform curl to service kubia to access the deployment <br>
```sh
  kubectl exec -it jump1 -- sh

  # while true; do curl http://kubia; echo ; sleep 5 ;  done
```

Perform these steps on terminal 1 <br>
```sh
kubectl set image deployment kubia nodejs=stv707/kubia:v2 --record
 # this will perform the update from v1 to v2 of the app

kubectl rollout history deployment kubia

kubectl get rs

# Monitor terminal 2 , for change in app from v1 to v2
``` 

# Lab12B
# Step
Rolling back a deployment<br>
Make sure Terminal 2 still running the while loop <br>

```sh
kubectl get pods

kubectl set image deployment kubia nodejs=stv707/kubia:v3 --record

kubectl rollout history deployment kubia

kubectl get rs
 # At this point only 1 rs will report with 2 ready Pods
 # Observe the terminal 2 , the app should report "Some internal error has occurred!" after 5 cycle of curl hit
 # Wait until all pod responds with "Some internal error has occurred!" before moving to next command 

kubectl rollout undo deployment kubia
 # this will undo the deployment of v3 and rolls back to v2 
 # Observe the terminal 2 , the app should report v2 is up and online

kubectl get rs 
 # v2 rs should report 2 pod ready 

kubectl rollout history deployment kubia

kubectl rollout undo deployment kubia --to-revision=1
 # This will roll back to revision 1 (recorded deployment ) and Terminal 2 should show app is now v1 
```

# Lab12C
# Step 
 # Controlling rollout using MaxSurge and MaxUnavailable
```sh 
 # Stop the while loop on terminal 2 and re-execute the while loop with sleep 1 
 # while true; do curl http://kubia; echo ; sleep 1 ;  done

kubectl delete deployments.apps kubia 

kubectl delete service kubia 

kubectl apply -f kubia-deployment-and-service-v1.yaml --record 
 
 # You should see v1 app kubia running 2 pod on Terminal 2 


sleep 10 && kubectl apply -f kubia-deployment-maxset-v4.yaml

# go to terminal 2 and observe the update from v1 to v4 will follow maxsurge and maxUnavailable
# Maxsurge will only bring 1 extra pod at a time
# maxUnavailable will only make maximum 1 old pod unavailable at one time

```

# Lab12D
# Step 
Blocking rollouts with readinessProbe<br>
Make sure Terminal 2 still running the while loop<br>
```sh
kubectl delete deployments.apps kubia 

kubectl delete service kubia 

kubectl apply -f kubia-deployment-and-service-v1.yaml 

# Go to terminal 2 and stop the while loop and rerun 
# You should see v1 of the app

cat kubia-deployment-v3-with-readinesscheck.yaml

kubectl apply -f kubia-deployment-v3-with-readinesscheck.yaml

kubectl rollout status deployment kubia
# control+c after you observe 

kubectl get pods
# shoud have 3 pod, but only 2 are in ready state, the 3rd pod are performing rediness probe which fails

kubectl describe deployments.apps kubia
# Obeserve the rediness probe ( will indicate it fails because v3 container images have bug)

kubectl rollout undo deployment kubia

kubectl rollout status deployment kubia

kubectl get pods
# one of the kubia pod should terminate

kubectl delete -f kubia-deployment-and-service-v1.yaml

```
You can control+c on terminal 2 to stop the while loop and issue exit.

END