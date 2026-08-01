#!/bin/bash

# Check if the SSL certificate already exists to avoid recreating it on container restart
if [ ! -f /etc/ssl/certs/nginx-selfsigned.crt ]; then
    echo "Generating self-signed SSL certificate..."
    
    # Create a self-signed certificate valid for 365 days
    # The -subj flag automatically answers the location/organization prompts
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/ssl/private/nginx-selfsigned.key \
        -out /etc/ssl/certs/nginx-selfsigned.crt \
        -subj "/C=MA/ST=Marrakesh-Safi/L=Ben Guerir/O=42/OU=Inception/CN=${DOMAIN_NAME}"
    
    echo "SSL Certificate generated successfully."
fi

# Replace the ${DOMAIN_NAME} variable in the config file with the actual environment variable
# We use sed to do a simple string replacement before starting the server
sed -i "s/\${DOMAIN_NAME}/$DOMAIN_NAME/g" /etc/nginx/conf.d/default.conf

echo "Starting NGINX in the foreground..."
# Start NGINX in the foreground (daemon off) so it acts as PID 1 and keeps the container alive
exec nginx -g "daemon off;"