FROM debian:bullseye-20240612

RUN apt update && apt install -y nginx openssl

RUN mkdir /keys && \
	openssl req -nodes -x509 -newkey rsa:4096 -days 3650 -sha256 \
	-keyout /etc/ssl/certs/cert-key.pem -out /etc/ssl/certs/cert.pem -subj "/"

COPY $PWD/tools /tools

CMD nginx -c /tools/nginx.conf
