#!/bin/bash

# Generate self-signed certificate
openssl req -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/nginx-selfsigned.crt -subj "/C=MO/L=KH/O=1337/OU=student/CN=jverdu-r.42.fr"

# Create Nginx configuration file
echo "
server {
    listen 443 ssl;
    listen [::]:443 ssl;

    server_name www.jverdu-r.42.fr jverdu-r.42.fr;

    ssl_certificate /etc/ssl/nginx-selfsigned.crt;
    ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key;

    ssl_protocols TLSv1.3;

    index index.php;
    root /var/www/html;

    location ~[^/]\.php(/|$) {
        try_files $uri $uri/ /index.php?$args;
        fastcgi_pass wordpress:9000;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }
}
" > /etc/nginx/sites-available/default

# Create symbolic link if it doesn't exist
if [ ! -L /etc/nginx/sites-enabled/default ]; then
    ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
fi

# Start Nginx
nginx -g "daemon off;"
