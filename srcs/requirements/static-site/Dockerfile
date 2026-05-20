FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y nodejs npm && rm -rf /var/lib/apt/lists/*

COPY ./html /var/www/html

WORKDIR /var/www/html

EXPOSE 3000

CMD ["npx", "serve", "-l", "3000"]
