#! /bin/bash
curl --write-out '%{http_code}' --silent --output /dev/null http://localhost:$HTTP_PORT/stat || exit 1