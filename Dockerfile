FROM centos:7
MAINTAINER Marco Palladino, marco@mashape.com

ENV KONG_VERSION 0.10.0

RUN yum install -y wget https://github.com/Mashape/kong/releases/download/$KONG_VERSION/kong-$KONG_VERSION.el7.noarch.rpm && \
    yum clean all

RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.1.3/dumb-init_1.1.3_amd64 && \
    chmod +x /usr/local/bin/dumb-init

RUN yum install -y net-tools

COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

IP_ADDR=`ifconfig eth0 | awk '$1 == "inet" {gsub(/\/.*$/, "", $2); print $2}'`
echo "SETTING IP_ADDR FOR KONG CLUSTERING TO: ${IP_ADDR}"

export KONG_CLUSTER_LISTEN="${IP_ADDR}:7946"

EXPOSE 8000 8443 8001 7946
CMD ["kong", "start"]
