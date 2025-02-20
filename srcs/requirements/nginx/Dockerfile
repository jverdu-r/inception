FROM nginx:stable-alpine

COPY conf/default.conf /etc/nginx/conf.d/default.conf
COPY certificates/cert.pem /etc/nginx/ssl/cert.pem
COPY certificates/key.pem /etc/nginx/ssl/key.pem

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
