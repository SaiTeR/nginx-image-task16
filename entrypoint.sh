#!/bin/sh

fcgiwrap -s unix:/var/run/fcgiwrap.socket &
echo "FastCGI запущен"

for i in $(seq 1 10); do
    if [ -e /var/run/fcgiwrap.socket ]; then
        echo "Сокет создан"
        chown nginx:nginx /var/run/fcgiwrap.socket
        echo "Права выданы"
        break
    fi
    echo "Ожидание создания сокета..."
    sleep 1
done


envsubst '${APACHE_IP} ${APACHE_PORT}' < /etc/nginx/sites-available/saiter.ddns-ip.net > /tmp/saiter.ddns-ip.net && \
    mv /tmp/saiter.ddns-ip.net /etc/nginx/sites-available/saiter.ddns-ip.net

exec nginx -g "daemon off;"
