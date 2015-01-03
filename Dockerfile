FROM	ubuntu:14.04

# Update the host
RUN	apt-get update
RUN apt-get -y dist-upgrade
RUN	apt-get -y install nodejs npm supervisor nginx

# Bundle app source
COPY resources/ /home/ubuntu/

# Install app dependencies
RUN	cp /usr/bin/nodejs /usr/bin/node
RUN cp /home/ubuntu/infra/supervisord.conf /etc/supervisor/supervisord.conf
RUN	mv /home/ubuntu/infra/.npmrc ~/.npmrc
RUN	cd /home/ubuntu/code/src; npm install ironsource
RUN mv /home/ubuntu/code/src/node_modules/ironsource /home/ubuntu/code/src
RUN rm -rf /home/ubuntu/code/src/node_modules/
RUN	cp /home/ubuntu/infra/nginx.conf /etc/nginx/nginx.conf
RUN	cp -R /home/ubuntu/infra/supervisor/* /etc/supervisor/conf.d/

EXPOSE  80
CMD 	["/usr/bin/supervisord"]
