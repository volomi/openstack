#!/bin/bash

cat > /etc/sysconfig/memcached <<EOL
PORT="11211"
USER="memcached"
MAXCONN="1024"
CACHESIZE="64"
OPTIONS="-l 0.0.0.0,::1"
EOL
