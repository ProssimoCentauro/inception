#!/bin/bash
set -e

if [ ! -f /var/lib/mysql/ibdata1 ]; then
    echo "Initializing MariaDB data directory..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

echo "Starting temporary MariaDB instance..."
mysqld --user=mysql --skip-networking --socket=/tmp/mysql.sock &
MYSQLD_PID=$!

echo "Waiting for socket..."
for i in {1..30}; do
    if mysqladmin --socket=/tmp/mysql.sock ping >/dev/null 2>&1; then
        break
    fi
    sleep 1
done

echo "Creating database and users..."
mysql --socket=/tmp/mysql.sock <<-EOSQL
    SET @@SESSION.SQL_LOG_BIN=0;
    CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
    CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
    FLUSH PRIVILEGES;
EOSQL

echo "Shutting down temporary instance..."
mysqladmin --socket=/tmp/mysql.sock shutdown
wait $MYSQLD_PID

echo "Starting final MariaDB daemon..."
exec mysqld --user=mysql
