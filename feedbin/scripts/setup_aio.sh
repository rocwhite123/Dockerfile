#!/usr/bin/env bash

umask 002

# Install packages
apt-get -qy update
apt-get -y install --no-install-recommends memcached openjdk-8-jdk postgresql redis-server sudo supervisor

curl -Ls https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/deb/elasticsearch/2.4.4/elasticsearch-2.4.4.deb > /tmp/elasticseaerch-2.4.4.deb && dpkg -i /tmp/elasticseaerch-2.4.4.deb
rm /tmp/elasticseaerch-2.4.4.deb

apt-get -qy clean

chmod -R g=u /etc/passwd

# ElasticSearch
mkdir -p /var/{lib,log,run}/elasticsearch
chgrp -R 0 /var/{lib,log,run}/elasticsearch /etc/elasticsearch
chmod -R g=u /var/{lib,log,run}/elasticsearch

# Redis
sed -i 's/daemonize yes/daemonize no/' /etc/redis/redis.conf
mkdir -p /var/{lib,log,run}/redis
chgrp -R 0 /var/{lib,log,run}/redis /etc/redis
chmod -R g=u /var/{lib,log,run}/redis

# Supervisor
sed -i /etc/supervisor/supervisord.conf \
    -e 's;/var/run/supervisor;/var/run/supervisor/supervisor;' \
    -e 's/^\[supervisord\]$/[supervisord]\nnodaemon = true/'
mkdir -p /var/{log,run}/supervisor
chgrp -R 0 /var/{log,run}/supervisor
chmod -R g=u /var/{log,run}/supervisor
