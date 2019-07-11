# use a node base image
FROM node:7-onbuild

# set maintainer
LABEL maintainer "mdabrar.bvb@gmail.com"


# set a health check
HEALTHCHECK --interval=5s \
            --timeout=5s \
            CMD curl -f http://127.0.0.1:8000 || exit 1

# tell docker what port to expose
CMD service status mysql
CMD service status iptables
CMD service status tomcat
EXPOSE 8000
