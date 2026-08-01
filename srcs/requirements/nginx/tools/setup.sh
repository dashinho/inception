#!/bin/bash

if [ ! -f /etc/ssl/certs/nginx-selfsigned.crt ]; then
    echo "Generating self-signed SSL certificate..."
    
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/ssl/private/nginx-selfsigned.key \
        -out /etc/ssl/certs/nginx-selfsigned.crt \
        -subj "/C=MA/ST=Marrakesh-Safi/L=Ben Guerir/O=42/OU=Inception/CN=${DOMAIN_NAME}"
    
    echo "SSL Certificate generated successfully."
fi

sed -i "s/\${DOMAIN_NAME}/$DOMAIN_NAME/g" /etc/nginx/conf.d/default.conf

echo "Starting NGINX in the foreground..."
exec nginx -g "daemon off;"