# ironSource Docker micro-services configuration
The container runs a Node.js application behind a Nginx reverse proxy.
Supervisor process control system runs our application within the container. 
Every docker container receives an entry point, a process to run when the container starts. 
The entry point to our container is the supervisor. 
Nginx and Node.js applications are started via the supervisor.
Supervisor also acts as a watchdog - in case the application crashes.

We use the c3.large instance type for most of our applications. Due to the fact that this instance type has 2 CPU cores. We run 2 Node.js processes listening on ports 8000 and 8001. 
Nginx listens on port 80 and acts as a reverse proxy to redirect traffic to the Node.js application instances on ports 8000-8001.

We use Ubuntu 14.04 both for the host and the container.

# Application build flow:
* CI server detects a merge to the branch of the application.
* Code build process is initiated which pushes the new code to our private npm repository.
* Container build process is initiated which builds the container and pushes it to a private docker repo.

# Container build process
* Ubuntu base image
* Security upgrades.
*  Installation of needed packages - nodejs npm supervisor nginx.
* Copy resources from the build machine into container.
* Place .conf files in the correct location inside the container.
* Checking out the latest stable code from the npm repository (artifactory) and place in correct location
* Expose port 80.
* Container entry point - supervisord.

# Amazon AMI bootstrap configuration
```bash
#AMI - c3.large - ubuntu 14.04 - user-data:
#!/bin/bash
sudo apt-get update
sudo apt-get -y dist-upgrade
sudo apt-get -y install docker.io
sudo docker login -u <user> -p <password> -e <email>
sudo docker pull user/container
sudo docker run -p 80:80 -d user/container
```
# Further research
* Use lightweight linux host and container OS (CoreOS?).
* Container OS monitoring (New Relic?).
* Use of a container management service (ECS?).
* Implementation of the system on Microsoft Azure.
