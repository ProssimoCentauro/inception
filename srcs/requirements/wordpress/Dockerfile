FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    php php-fpm php-mysql php-redis php-curl php-gd php-mbstring php-xml \
    curl mariadb-client && rm -rf /var/lib/apt/lists/*

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY tools/init_wp.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init_wp.sh

EXPOSE 9000

CMD ["/usr/local/bin/init_wp.sh"]
