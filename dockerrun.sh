#! /bin/bash

envsubst "$(env | sed -e 's/=.*//' -e 's/^/\$/g')" < \
  /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf && \
  cat /etc/nginx/nginx.conf > /dev/stdout && \
  nginx > /dockerrun.sh