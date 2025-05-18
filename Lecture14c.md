# Connecting to the MySQL server from a second container running the MySQL client utility

## Run the Backend and Frontend App

Clone the backend-app repository from [here](https://github.com/theGameChangerDev/ChristabossGlobalResourceBackend)

#### Backend

Create a `.env` file containing connection details to the database

```
sudo vi .env


DB_HOST=mysqlserverhost
DB_NAME=tododb
DB_USER=mayor
DB_PASSWORD=newPassword
DB_CONNECTION=mysql
DB_PORT=3306
PORT=3000
```

------
DB_HOST mysql ip address “leave as mysqlserverhost”
DB_DATABASE mysql databse name
DB_USERNAME mysql username for user export as environment variable
DB_PASSWORD mysql password for the user exported as environment varaible
DB_CONNECTION mysql connection "leave as mysql"
DB_PORT mysql port "leave as 3306"

Containerization of an application starts with creation of a file with a special name - 'Dockerfile' (without any extensions). This can be considered as a 'recipe' or 'instruction' that tells Docker how to pack your application into a container. In this project, you will build your container from a pre-created `Dockerfile`, but as a DevOps, you must also be able to write Dockerfiles.

You can watch [this video](https://www.youtube.com/watch?v=hnxI-K10auY) to get an idea how to create your `Dockerfile` and build a container from it.

And on [this page](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/), you can find official Docker best practices for writing Dockerfiles.

So, let us containerize our backend application; here is the plan:

- Make sure you have checked out your backend repo to your machine with Docker engine

- First, we need to build the Docker image the backend app will use. The Backend repo you cloned above has a `Dockerfile` for this purpose. Explore it and make sure you understand the code inside it.

- Run `docker build` command

- Launch the container with `docker run`

- Try to access your application via port exposed from a container

Ensure you are inside the folder that has the `Dockerfile` and build your container:

```
docker build -t christaboss-backend:1.0.0 .
```

In the above command, we specify a parameter `-t`, so that the image can be tagged `christaboss-backend:1.0.0` - Also, you have to notice the `.` at the end. This is important as that tells Docker to locate the `Dockerfile` in the current directory you are running the command. Otherwise, you would need to specify the absolute path to the `Dockerfile`.

```
docker run --network cglobr_network --name backend-cont -p 3000:3000 -d christaboss-backend:1.0.0
```

Let us observe those flags in the command.

- We need to specify the `--network` flag so that both the Backend app and the database can easily connect on the same virtual network we created earlier.
- The `-p` flag is used to map the container port with the host port.


### Frontend

Clone the frontend-app repository from [here](https://github.com/theGameChangerDev/ChristabossGlobalResourceFrontend)

Let us containerize our frontend application; here is the plan:

- Make sure you have checked out your frontend repo to your machine if you havn't done that

- We need to build the Docker image the frontend app will use. The Frontend repo you cloned above has a `Dockerfile` for this purpose. Explore it and make sure you understand the code inside it.

- Run `docker build` command

- Launch the container with `docker run`

- Try to access your application via port exposed from a container

Ensure you are inside the folder that has the `Dockerfile` and build your container:

```
docker build -t christaboss-frontend:1.0.0 .
```

In the above command, we specify a parameter `-t`, so that the image can be tagged `christaboss-frontend:1.0.0` - Also, you have to notice the `.` at the end. This is important as that tells Docker to locate the `Dockerfile` in the current directory you are running the command. Otherwise, you would need to specify the absolute path to the `Dockerfile`.

```
docker run --network cglobr_network --name frontend-cont -p 80:80 -d christaboss-frontend:1.0.0
```

Now, access your website on

```
localhost:80
```
