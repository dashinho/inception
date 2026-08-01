FROM debian:bullseye

# Update package lists and install NGINX and OpenSSL
RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Create the directory where NGINX expects to find the SSL certificates
RUN mkdir -p /etc/ssl/certs /etc/ssl/private

# Remove the default NGINX configuration
RUN rm /etc/nginx/sites-enabled/default

# Copy our custom server block configuration
COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

# Copy the setup script and make it executable
COPY tools/setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

# Expose port 443 (as required by the subject)
EXPOSE 443

# Run the setup script to generate certs and start the server
ENTRYPOINT ["/usr/local/bin/setup.sh"]