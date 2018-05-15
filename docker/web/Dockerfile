FROM centos:7

RUN yum install -y epel-release
RUN yum install -y nginx

ARG APPLICATION_ROOT_PATH
ENV RAILS_ROOT $APPLICATION_ROOT_PATH

WORKDIR $RAILS_ROOT

# create log directory
RUN mkdir log

# copy over static assets
COPY public public/

COPY docker/web/nginx.conf /etc/nginx/conf.d/default.conf

RUN mkdir -p /run/nginx

EXPOSE 80

CMD [ "nginx", "-g", "daemon off;" ]
