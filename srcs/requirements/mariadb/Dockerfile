FROM mariadb:latest

COPY conf/ /docker-entrypoint-initdb.d/

EXPOSE 3306

CMD ["mysqld"]