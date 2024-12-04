FROM nginx:alpine

RUN apk add fcgiwrap

# Копируем сертификаты
COPY config/certs/saiter.serveminecraft.net/ /etc/letsencrypt/live/saiter.serveminecraft.net/
COPY config/certs/options-ssl-nginx.conf /etc/letsencrypt
COPY config/certs/ssl-dhparams.pem /etc/letsencrypt

# Копируем конфигурации сайтов
COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/conf.d/default.conf /etc/nginx/conf.d

COPY config/sites-available/ /etc/nginx/sites-available/
RUN mkdir -p /etc/nginx/sites-enabled && \
    ln -s /etc/nginx/sites-available/* /etc/nginx/sites-enabled/

# Копируем статические файлы
COPY static/ /var/www/nginx_serv

# Настраиваем скрипт get_cpu_usage.sh
RUN chmod +x /var/www/nginx_serv/get_cpu_usage.sh && \
    chown nginx:nginx /var/www/nginx_serv/get_cpu_usage.sh

    
# Добавляем скрипт для корректного запуска контейнера
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80
EXPOSE 443

CMD ["/entrypoint.sh"]


