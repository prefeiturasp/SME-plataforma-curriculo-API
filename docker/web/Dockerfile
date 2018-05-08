FROM centos:7

RUN yum install -y epel-release
RUN yum install -y nginx

# establish where Nginx should look for files
ENV RAILS_ROOT /mnt/data/patio-digital

# Set our working directory inside the image
WORKDIR $RAILS_ROOT

# create log directory
RUN mkdir log

# copy over static assets
COPY public public/

COPY docker/web/nginx.conf /etc/nginx/conf.d/default.conf

RUN mkdir -p /run/nginx

EXPOSE 80

CMD [ "nginx", "-g", "daemon off;" ]
