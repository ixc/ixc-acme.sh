#!/bin/bash

set -e

mkdir -p /opt/acme.sh-nginx/run
dockerize -template /opt/acme.sh-nginx/etc/nginx.tmpl.conf:/opt/acme.sh-nginx/etc/nginx.conf
exec nginx -c /opt/acme.sh-nginx/etc/nginx.conf -g 'pid /opt/acme.sh-nginx/run/nginx.pid;' "$@"
