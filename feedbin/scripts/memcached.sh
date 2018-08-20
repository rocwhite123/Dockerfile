#!/usr/bin/env bash

USER="$(whoami)"
[ "$USER" == 'root' ] && USER=memcache

exec /usr/bin/memcached -m 64 -p 11211 -u $USER -l 127.0.0.1
