FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y php php-mysql php-pdo php-mysqli curl && rm -rf /var/lib/apt/lists/*

RUN curl -L https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php -o /var/www/html/index.php

EXPOSE 8080

CMD ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/html"]
