#!/usr/bin/env bash

source /srv/scripts/setup_env.sh

cd $HOME

export POSTGRES_USER="${POSTGRES_USER:-postgres}"
export POSTGRES_PASSWORD="${POSTGRES_PASSWORD:-postgres}"
export POSTGRES_HOST="${POSTGRES_HOST:-127.0.0.1}"
export POSTGRES_DB="${POSTGRES_DB:-feedbin}"
export DATABASE_URL=postgres://$POSTGRES_USER:$POSTGRES_PASSWORD@$POSTGRES_HOST/$POSTGRES_DB

export MEMCACHED_HOST="${MEMCACHED_HOST:-127.0.0.1}"
export MEMCACHED_HOSTS=${MEMCACHED_HOST}:11211

export REDIS_HOST="${REDIS_HOST:-127.0.0.1}"
rds_ip="$(getent hosts $REDIS_HOST | awk '{print $1}')"
export REDIS_URL="redis://${rds_ip}:6379"

export ELASTIC_SEARCH_HOST="${ELASTIC_SEARCH_HOST:-127.0.0.1}"
es_ip="$(getent hosts $ELASTIC_SEARCH_HOST | awk '{print $1}')"
export ELASTICSEARCH_URL="http://${es_ip}:9200"

[ -n "$NUM_UNICORN_WORKER" ] && sed -E -i "s/^ *worker_processes .+/worker_processes $NUM_UNICORN_WORKER/" config/unicorn.rb

# psql -lqt "$DATABASE_URL" | cut -d \| -f 1 | grep -qw "$POSTGRES_DB" || \
bundle exec rake db:setup

exec bundle exec foreman start
