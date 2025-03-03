FROM debian:bullseye-20240612

EXPOSE 3306

RUN apt update && apt install -y mariadb-server

COPY $PWD/tools/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY $PWD/tools/mariadb.cnf /etc/mysql/mariadb.cnf
COPY $PWD/tools/script.sh /script.sh

CMD bash /script.sh
