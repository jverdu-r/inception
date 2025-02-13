FROM nginx:stable-alpine

# Install OpenSSL
RUN apk add --no-cache openssl

# Set working directory
WORKDIR /var/www/html

# Copy Nginx configuration
COPY conf/ /etc/nginx/conf.d/
COPY ./conf/default.conf /etc/nginx/conf.d/default.conf

# Create a directory for SSL certificates
RUN mkdir -p /etc/nginx/ssl

# Copy SSL certificates (if they exist)
COPY certificates/ /etc/nginx/ssl/

# Copy and set up the entrypoint script
#COPY tools/entrypoint.sh /entrypoint.sh
#RUN chmod +x /entrypoint.sh

# Expose HTTPS port
EXPOSE 443

# Set entrypoint script
ENTRYPOINT ["/entrypoint.sh"]

# Start Nginx
ENTRYPOINT ["/bin/sh", "-c"] # Override the default entrypoint
CMD ["nginx", "-g", "daemon off;"] # Your original CMD instruction

