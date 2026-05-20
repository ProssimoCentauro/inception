FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y nginx openssl && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/rtodaro.42.fr.key \
    -out /etc/nginx/ssl/rtodaro.42.fr.crt \
    -subj "/C=IT/ST=Italy/L=Rome/O=42/CN=rtodaro.42.fr"

COPY conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
