#!/usr/bin/env bash

source /srv/scripts/setup_env.sh

exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
