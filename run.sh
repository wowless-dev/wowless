set -e
gcsfuse --implicit-dirs wowless.dev $PWD/wowless/mount
/usr/local/openresty/nginx/sbin/nginx -p . -c nginx.conf
