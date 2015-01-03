This is a template we use for Node.JS applications within Docker.

The container runs a Node.js application behind a Nginx reverse proxy and the supervisor process control system runs our application within the container. 
Every docker container receives an entry point, a process to run when the container starts. 
The entry point to our container is the supervisor. 
Nginx and Node.js applications are started via the supervisor.
Supervisor also acts as a watchdog - in case the application crashes.

We use the c3.large instance type for most of our applications. Due to the fact that this instance type has 2 CPU cores. We run 2 Node.js processes listening on ports 8000 and 8001. 
Nginx listens on port 80 and acts as a reverse proxy to redirect traffic to the Node.js application instances on ports 8000-8001.

We use Ubuntu 14.04 both for the host and the container.

Application build flow:
1. CI server detects a merge to the branch of the application.
2. Code build process is initiated which pushes the new code to our private npm repository.
3. Container build process is initiated which builds the container and pushes it to a private docker repo.

Container build process
1. Ubuntu base image
2. Security upgrades.
3. Installation of needed packages - nodejs npm supervisor nginx.
4. Copy resources from the build machine into container.
5. Place .conf files in the correct location inside the container.
6. Checking out the latest stable code from the npm repository (artifactory) and place in correct location
7. Expose port 80.
8. Container entry point - supervisord.

Further research
1. Use lightweight linux host and container OS (CoreOS?)
2. Container OS monitoring (New Relic?)
3. Use of a container management service (ECS?)
4. Implementation of the system on Microsoft Azure.
