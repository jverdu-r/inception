From nginx:latest

COPY conf/ /etc/nginx/conf.d/

COPY certificates/ /etc/nginx/certificates/

WORKDIR /var/www/html

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]