FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y vsftpd && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/vsftpd && \
    chown root:root /var/run/vsftpd && \
    chmod 755 /var/run/vsftpd

COPY conf/vsftpd.conf /etc/vsftpd.conf
COPY tools/init_vsftpd.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init_vsftpd.sh

EXPOSE 20-21 30000-30009

CMD ["/usr/local/bin/init_vsftpd.sh"]
