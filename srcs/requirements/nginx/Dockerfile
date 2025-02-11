From nginx:latest

COPY conf/ /etc/nginx/conf.d/

COPY certificates/ /etc/nginx/certificates/

WORKDIR /var/www/html

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]

FROM nginx:stable-alpine

# Install OpenSSL
RUN apk add --no-cache openssl

# Copy default.conf to Nginx config directory
COPY ./conf/default.conf /etc/nginx/conf.d/default.conf

# Create a directory for SSL certificates
RUN mkdir -p /etc/nginx/ssl

# Copy entrypoint script
COPY ./tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set entrypoint script
ENTRYPOINT ["/entrypoint.sh"]

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]

