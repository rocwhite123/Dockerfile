#!/usr/bin/env bash

export ES_JAVA_OPTS="${ES_JAVA_OPTS:--Xms64m -Xmx64m}"

cmd="/usr/share/elasticsearch/bin/elasticsearch -Des.pidfile=${PID_DIR}/elasticsearch.pid -Des.default.path.home=${ES_HOME} -Des.default.path.logs=${LOG_DIR} -Des.default.path.data=${DATA_DIR} -Des.default.path.conf=${CONF_DIR}"

USER="$(whoami)"
if [ "$USER" == 'root' ]; then
  sudo -u elasticsearch exec $cmd
else
  exec $cmd
fi
