#!/usr/bin/env bash

export HOME='/srv/apps/feedbin/current'
if ! whoami &> /dev/null; then
    if [ -w /etc/passwd ]; then
        echo "${USER_NAME:-default}:x:$(id -u):0:${USER_NAME:-default} user:${HOME}:/sbin/nologin" >> /etc/passwd
    fi
fi

export RACK_ENV="${RACK_ENV:-production}"
export RAILS_ENV="${RAILS_ENV:-production}"
export RAILS_SERVE_STATIC_FILES="${RAILS_SERVE_STATIC_FILES:-true}"
