FROM	ubuntu:14.04

# Update the host
RUN	apt-get update \
	&& apt-get -y dist-upgrade \
	&& apt-get -y install nodejs npm supervisor nginx

# Bundle app source
COPY resources/ /home/ubuntu/

# Install app dependencies
RUN	cp /usr/bin/nodejs /usr/bin/node \
	&& cp /home/ubuntu/infra/supervisord.conf /etc/supervisor/supervisord.conf \
  	&& cd /home/ubuntu/infra; mv .npmrc ~/.npmrc \
	&& cd /home/ubuntu/code/src; npm install ironsource-synergy \
	&& mv /home/ubuntu/code/src/node_modules/ironsource-synergy /home/ubuntu/code/src \
	&& rm -rf /home/ubuntu/code/src/node_modules/ \
	&& cp /home/ubuntu/infra/nginx.conf /etc/nginx/nginx.conf \
	&& cp -R /home/ubuntu/infra/supervisor/* /etc/supervisor/conf.d/
	
EXPOSE  80

CMD 	["/usr/bin/supervisord"]
