FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y nodejs npm && rm -rf /var/lib/apt/lists/*

RUN npm install -g redis-commander

EXPOSE 8081

CMD ["redis-commander", "--redis-host", "redis", "--redis-port", "6379", "--http-port", "8081"]
