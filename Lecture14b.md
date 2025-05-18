#### MySQL in container

Let us start assembling our application from the Database layer - we will use a pre-built MySQL database container, configure it, and make sure it is ready to receive requests from our Node Js application.

##### Step 1: Pull MySQL Docker Image from [Docker Hub Registry](https://hub.docker.com)

Start by pulling the appropriate [Docker image for MySQL](https://hub.docker.com/_/mysql). You can download a specific version or opt for the latest release, as seen in the following command:

```
docker pull mysql/mysql-server:latest
```

If you are interested in a particular version of MySQL, replace `latest` with the version number. Visit Docker Hub to check other tags [here](https://hub.docker.com/r/mysql/mysql-cluster/tags)

List the images to check that you have downloaded them successfully:

```
docker image ls
```

<!-- 1. Once you have the image, move on to deploying a new MySQL container with:

```
docker run --name <container_name> -e MYSQL_ROOT_PASSWORD=<my-secret-pw> -d mysql/mysql-server:latest
```

In our case

```
docker run --name cglobrdb -e MYSQL_ROOT_PASSWORD=Password.1 -d mysql/mysql-server:latest
```

- Replace `<container_name>` with the name of your choice. If you do not provide a name, Docker will generate a random one
- The -d option instructs Docker to run the container as a service in the background
- Replace `<my-secret-pw>` with your chosen password
- In the command above, we used the latest version tag. This tag may differ according to the image you downloaded

2. Then, check to see if the MySQL container is running: Assuming the container name specified is `mysql-server`

```
docker ps -a
```

```
CONTAINER ID   IMAGE                       COMMAND                  CREATED              STATUS                            PORTS                       NAMES
749ef2c37869   mysql/mysql-server:latest   "/entrypoint.sh mysq…"   10 seconds ago       Up 9 seconds (health: starting)   3306/tcp, 33060-33061/tcp   cglobrdb
```

You should see the newly created container listed in the output. It includes container details, one being the status of this virtual environment. The status changes from `health: starting` to `healthy`, once the setup is complete.

##### Step 3: Connecting to the MySQL Docker Container

We can either connect directly to the container running the MySQL server or use a second container as a MySQL client. Let us see what the first option looks like.

**Approach 1**

Connecting directly to the container running the MySQL server:

```
docker exec -it <container_name> mysql -uroot -p
```

In our case

```
docker exec -it cglobrdb mysql -uroot -p
```

Provide the root password when prompted. With that, you have connected the MySQL client to the server.

```
docker exec -it cglobrdb mysql -uroot -p
Enter password: 

Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 11
Server version: 8.0.32 MySQL Community Server - GPL

Copyright (c) 2000, 2023, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> 
```

EXIT 

Finally, change the server root password to protect your database. -->
##### Step 2: Deploy the MySQL Container to your Docker Engine

1. Once you have the image, move on to deploying a new MySQL container :

First, create a network:

```
docker network create --subnet=192.168.100.0/24 cglobr_network
```

Creating a custom network is not necessary because even if we do not create a network, Docker will use the default network for all the containers you run. By default, the network we created above is of `DRIVER` `Bridge`. So, also, it is the default network. You can verify this by running the `docker network ls` command.

But there are use cases where this is necessary. For example, if there is a requirement to control the `cidr` range of the containers running the entire application stack. This will be an ideal situation to create a network and specify the `--subnet`

For clarity's sake, we will create a network with a subnet dedicated for our project and use it for both MySQL and the application so that they can connect.

Run the MySQL Server container using the created network.

First, let us create an environment variable to store the root password:

```
export MYSQL_PW=Password.1
```

Then, pull the image and run the container, all in one command like below:


```
docker run --network cglobr_network -h mysqlserverhost --name=cglobrdb -e MYSQL_ROOT_PASSWORD=$MYSQL_PW  -d mysql/mysql-server:latest 
```


- Replace `<container_name>` with the name of your choice. If you do not provide a name, Docker will generate a random one
- The -d option instructs Docker to run the container as a service in the background
- Replace `<my-secret-pw>` with your chosen password
- In the command above, we used the latest version tag. This tag may differ according to the image you downloaded

Flags used

- `-d` runs the container in detached mode
- `--network` connects a container to a network
- `-h` specifies a hostname


- Then, check to see if the MySQL container is running: Assuming the container name specified is `cglobrdb`

```
docker ps -a
```

```
CONTAINER ID   IMAGE                       COMMAND                  CREATED              STATUS                            PORTS                       NAMES
749ef2c37869   mysql/mysql-server:latest   "/entrypoint.sh mysq…"   10 seconds ago       Up 9 seconds (health: starting)   3306/tcp, 33060-33061/tcp   cglobrdb
```

You should see the newly created container listed in the output. It includes container details, one being the status of this virtual environment. The status changes from `health: starting` to `healthy`, once the setup is complete.


If the image is not found locally, it will be downloaded from the registry.

As you already know, it is best practice not to connect to the MySQL server remotely using the root user. Therefore, we will create an `SQL` script that will create a user we can use to connect remotely.

Create a file and name it `create_user.sql` and add the below code in the file:

```
CREATE USER '<user>'@'%' IDENTIFIED BY '<client-secret-password>';
GRANT ALL PRIVILEGES ON * . * TO '<user>'@'%';
CREATE DATABASE <dbname>;
```

```
CREATE USER 'mayor'@'%' IDENTIFIED BY 'Password.1';
GRANT ALL PRIVILEGES ON * . * TO 'mayor'@'%';
CREATE DATABASE tododb;
```

Run the script:

```
docker exec -it cglobrdb mysql -uroot -p$MYSQL_PW < ./create_user.sql
```

If you see a warning like below, it is acceptable to ignore:

```
mysql: [Warning] Using a password on the command line interface can be insecure.
```
