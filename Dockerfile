FROM centos

MAINTAINER ZerounYang

# MariaDB Repo
COPY mariadb.repo /etc/yum.repos.d/mariadb.repo

# Install required packages and MariaDB Vendor Repo
RUN yum -y update && \
    rpm --import https://yum.mariadb.org/RPM-GPG-KEY-MariaDB && \
    groupadd -r mysql && useradd -r -g mysql mysql && \
    yum -y install MariaDB-server MariaDB-client galera which && \
    yum clean all && \
    mkdir /docker-entrypoint-initdb.d

COPY server.cnf /etc/my.cnf.d/server.cnf
COPY docker-entrypoint.sh /docker-entrypoint.sh

VOLUME /var/lib/mysql
EXPOSE 3306 4444 4567 4568 
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["mysqld"]
