FROM debian:bullseye-20240612

RUN apt update && apt install -y php7.4-fpm php7.4-mysql curl sendmail procps sudo && mkdir -p /run/php

RUN echo "www-data ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

#install wp-cli
RUN curl https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -o /usr/bin/wp-cli.phar && chmod 755 /usr/bin/wp-cli.phar

EXPOSE 9000

COPY $PWD/tools/www.conf /etc/php/7.4/fpm/pool.d/www.conf

COPY $PWD/tools /tools

# Explicitly specify the download path
#RUN /usr/bin/wp-cli.phar core download --allow-root --path=/usr/share/wordpress/

#RUN ls -l /usr/share/wordpress/

#RUN chown -R www-data:www-data /usr/share/wordpress/

#RUN chmod -R 755 /usr/share/wordpress/

CMD bash /tools/script.sh
