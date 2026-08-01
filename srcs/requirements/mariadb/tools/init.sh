#!/bin/bash

# Start the MariaDB service temporarily in the background to configure it
service mariadb start

# Wait for the database to fully start
sleep 2

# Create the database and user using environment variables
mariadb -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
mariadb -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mariadb -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"

# Secure the root user
mariadb -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
mariadb -e "FLUSH PRIVILEGES;"

# Shut down the temporary background service cleanly
mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown

# Execute MariaDB in the foreground to keep the container running (PID 1)
exec mysqld_safe