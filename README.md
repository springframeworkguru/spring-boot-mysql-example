# Online store

## Resources 
 The original spring-boot application was inspired from [here](https://github.com/springframeworkguru/spring-boot-mysql-example)
## Steps to build locally 
### 1 - First, ensure to have Java JDK/JRE and maven installed on your local machine </br>
&nbsp; a - install Java JDK by running the command `sudo apt install default-jdk -y`</br>
&nbsp; b - install Java JRE by running the command `sudo apt install default-jre -y`</br>
&nbsp; c - install maven bwith `sudo apt install maven -y`</br>
### 2 - Second, install and configure mysql </br>
&nbsp; a - install from [here](https://linuxize.com/post/how-to-install-mysql-on-ubuntu-18-04/) </br>
&nbsp; b - configure mysql by creating a user with `mysql_native_password` for the authentication method. You can take guidance from [here](https://linuxize.com/post/how-to-manage-mysql-databases-and-users-from-the-command-line/#create-a-new-mysql-user-account) </br>
&nbsp; c - create database for the application ( use the same guide above )</br>
### 3 - Put the information in a new `.env` file
```
MYSQL_DB_HOST=
MYSQL_DB_PORT=
MYSQL_DB_USERNAME=
MYSQL_DB_PASSWORD=
MYSQL_DB_DNAME=
```
&nbsp; Note: all names and passwords will be updated in the `src/main/resources/application.properties` file </br>
### 4 - Build the jar file and run</br>
&nbsp; a - Run the command `mvn clean install`. This will create a directory named `target`.</br>
&nbsp; b - navigate to the `target` directory and run the jar file with `java -jar <file_name.jar>`</br>
## Build locally using Docker 
### 1 - Install Docker & Docker-Compose </br>
&nbsp; a - Install docker from the official documentation [here](https://docs.docker.com/engine/install/ubuntu/) </br>
&nbsp; b - Install docker-compose from the official documentation [here](https://docs.docker.com/compose/install/) </br>
&nbsp; Note: If you choose to build with docker, you will not need all the previous installation for running the project locally. You only need to install docker and docker-compose and it saves you the hassle of installing JDK, JRE, maven, and even mysql.

### 2 - Put the information in a new `.env` file
&nbsp; For the sake of consistency, we use the same name while building locally </br>
```
MYSQL_DB_HOST=db  #this one is necessary as it is the service name in docker-compose.yaml file
MYSQL_DB_PORT=3306 #this is the default port used by mysql official image so don't choose any port else
MYSQL_DB_USERNAME=
MYSQL_DB_PASSWORD=
MYSQL_DB_DNAME=
```
### 3 - Build and Run
&nbsp; Run the command `docker-compose up` in the directory where docker files are. Docker will first pull the needed images and start working. </br>
&nbsp; If you want to edit the configurations and build again, run `docker-compose up --build` to ignore chache and start building again. </br>

## Deploy with kubernetes  
### 1 - Install minikube </br>
&nbsp; a - For testing purposes, we can deploy all our kubernetes deployments on a locally created single-node cluster with minikube [here](https://minikube.sigs.k8s.io/docs/start/) </br>
&nbsp; Note: If you are running your ubuntu on a virtual machine upon other OS, you may need to follow this [guide](https://webme.ie/how-to-run-minikube-on-a-virtualbox-vm/) instead. </br>

### 2 - Put the information in a new `secret.yaml` file (all files are in the k8s_yaml directory)
&nbsp; a - Here, we will replace the `.env` file with two files. A configmap.yaml which contains non-sensetive data to be accessible by all cluster resources (this one is created for you and is present in the repository. </br>
&nbsp; b - A secret.yaml which contains sensetive data that not to be shared on publuic repository so create the file first and fill the data below </br>

```
apiVersion: v1
kind: Secret
metadata:
    name: mysql-secret
type: Opaque
data:
    MYSQL_DB_PORT: 
    MYSQL_DB_USERNAME: 
    MYSQL_DB_PASSWORD: 
    MYSQL_DB_DNAME: 
```
&nbsp; Important Note: you can not just place the values in the secrets file as a plain text, first you will need to encode them to base64 (as k8s will decode them by default). And the way to do this in linux `echo -n text | base64 `, or you can use a website like [here](https://www.base64decode.org/)</br>

### 3 - Build and Run with external ip 
&nbsp; a - You will need to run `kubectl apply -f <file_name>.yaml` to apply the configurations of each file. But due to using secrets and services, you will need to execute them in specific order </br>
&nbsp;&nbsp; I - secrets file </br>
&nbsp;&nbsp; II - mysql deployment files </br>
&nbsp;&nbsp; III - mysql service files </br>
&nbsp;&nbsp; IV - config map file </br>
&nbsp;&nbsp; V - online-store deployment file </br>
&nbsp;&nbsp; VI - online-store-service file </br>
&nbsp; b - The loadbalancer used in online-store-service will assign an external ip → with using minikube, it will be in pending state until you allow it to take ip by typing “minikube service <NAME_OF_SERVICE>”

&nbsp;Note: If you want to edit any of the configurations, run `kubectl apply -f <file_name>.yaml`. </br>

### 4 - Build and Run with ingress and domain name 
&nbsp; a - The configuration files used for this are online-store-ingress.yaml and online-store-internal-service.yaml (this will be applied instead of online-store-service.yaml) </br>
&nbsp; b - Install the ingress-controller pod in your k8s cluster → with minikube you type `minikube addons enable ingress`and it will be added in the kube-system namespace </br>
&nbsp; c - apply online-store-internal-service.yaml ( note that if you used the above steps exactly, you will have 2 services mapping to the same deployment and it is fine for testing. Otherwise, delete the service online-store-service ) </br>
&nbsp; d - apply the online-store-ingress.yaml ( note that you will replace the file in step 6 above with ) </br>
&nbsp; e - this will create an IP address to the hostname osama.com → type `kubectl get ingress` to know </br>
&nbsp; f - For testing and with using minikube, this is a dummy hostname that is not available publicly. So we have to map it explicitly to the address created by minkube </br>
&nbsp; g - to map in your linux, type `sudo nano /etc/hosts` → add the IP address created in step 5 and the hostname associated with it osama.com </br>
&nbsp; h - Go to osama.com in your browser to open the application </br>
