# eks-terraform for timeoff app

## APP repo

https://github.com/afreydev/timeoff-management-application

- The Dockerfile had to be updated to run correctly. It had errors related to the base image and the sqlite package.
- It was added a helm chart to deploy the image in k8s clusters.

## Architecture

![Architecture](https://github.com/afreydev/gor-eks-terraform/blob/main/images/architecture.png?raw=true)

1. To deploy the app we have an [kubernetes cluster](https://github.com/afreydev/gor-eks-terraform/tree/main/cluster) implemented using eks service in aws. This a good option because k8s is a portable technology so the solution could be moved to another provided in an "easier" way compared to other privative platforms. Using k8s we can scale the application and we could implement different deployment methods like canary deployments or blue green aproaches.

2. To deploy the infrastructure you need to create a key for the tls and put it in the cluster folder. 
```openssl req \
-x509 -newkey rsa:4096 -sha256 -nodes \
-keyout tls.key -out tls.crt \
-subj "/CN=timeoff" -days 365
```
3. In the cluster folder, you can run ```terraform plan``` and  ```terraform apply``` to create the infrastructure.

4. If you want to access to the cluster you can generate your kubeconfig by using this command:
``` aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)```

4. You must run ```terraform apply``` in the helm folder to install the nginx ingress in the cluster. This is a component to manage the different routes in the cluster to avoid using a lot of load balancers. Change the path of your kubeconfig file [here](https://github.com/afreydev/gor-eks-terraform/blob/main/helm/vars.tf).

5. In the dns folder you could run ```terraform apply``` to set the dns (if you have a domain). You only need to pass the subdomain as variable (cname_record_value).

4. For deploying the app, we have a custom [helm chart](https://github.com/afreydev/timeoff-management-application/tree/master/helm/timeoff) developed for this project. . It can be used passing the parameter tag, to say to the deployment (in k8s) what version it should use. 

5. Any change in the master branch triggers the build and deploy pipeline. You can see its status [here](https://github.com/afreydev/timeoff-management-application/actions).

6. For cicd platform, the architecture includes a [github actions pipeline](https://github.com/afreydev/timeoff-management-application/blob/master/.github/workflows/build-and-deploy.yml). This is a good option basically cause it works well integrated with github (the repos are located there). The pipeline has 2 stages: build and deploy. The first one would be more related to ci (we could included tests there) and the second one more related to cd, because it includes the conection to the k8s cluster and the deploy using a custom helm chart. 

7. Dockerhub is used to storage the [docker image versions of the app](https://hub.docker.com/r/afreydev/timeoff/tags). The images are pushed in the build stage in the cicd pipeline. And they are pulled directly from k8s when we deploy a new version of the app.
