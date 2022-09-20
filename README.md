# eks-terraform for timeoff app

## Architecture

![Architecture](https://github.com/afreydev/gor-eks-terraform/blob/main/images/architecture.png?raw=true)

1. To deploy the app we have an [kubernetes cluster](https://github.com/afreydev/gor-eks-terraform/tree/main/cluster) implemented using eks service in aws. This a good option because k8s is a portable technology so the solution could be moved to another provided in an "easier" way compared to other privative platforms. Using k8s we can scale the application and we could implement different deployment methods like canary deployments or blue green aproaches.

2. To deploy the infrastructure you need to create a key for the tls and put it in the cluster folder. 
```openssl req \
-x509 -newkey rsa:4096 -sha256 -nodes \
-keyout tls.key -out tls.crt \
-subj "/CN=timeoff" -days 365
```
3. You can run ```terraform plan``` and  ```terraform apply``` to create the infrastructure.

3. For deploying the app, we have a custom [helm chart](https://github.com/afreydev/timeoff-management-application/tree/master/helm/timeoff) developed for this project. . It can be used passing the parameter tag, to say to the deployment (in k8s) what version it should use.

4. For cicd platform, the architecture includes a [github actions pipeline](https://github.com/afreydev/timeoff-management-application/blob/master/.github/workflows/build-and-deploy.yml). This is a good option basically cause it works well integrated with github (the repos are located there). The pipeline has 2 stages: build and deploy. The first one would be more related to ci (we could included tests there) and the second one more related to cd, because it includes the conection to the k8s cluster and the deploy using a custom helm chart. 

5. Dockerhub is used to storage the [docker image versions of the app](https://hub.docker.com/r/afreydev/timeoff/tags). The images are pushed in the build stage in the cicd pipeline. And they are pulled directly from k8s when we deploy a new version of the app.
