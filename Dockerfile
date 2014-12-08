FROM debian:wheezy

ADD http://resources.mpi-inf.mpg.de/yago-naga/aida/download/entity-repository/AIDA_entity_repository_2010-08-17v7.sql.bz2 AIDA_entity_repository_2010-08-17v7.sql.bz2

RUN apt-get update && apt-get install -y \
  git \
  openjdk-7-jdk \
  maven \
  postgresql \

RUN git clone https://github.com/yago-naga/aida.git
RUN cd aida
RUN mvn package
RUN cp sample_settings/aida.properties settings/
echo "dataSourceClassName=org.postgresql.ds.PGSimpleDataSource" >> settings/database_aida.properties
echo "dataSource.serverName = localhost" >> settings/database_aida.properties
echo "dataSource.databaseName = aida" >> settings/database_aida.properties
echo "dataSource.user = docker" >> settings/database_aida.properties
echo "dataSource.password = docker" >> settings/database_aida.properties
echo "dataSource.portNumber = 5432" >> settings/database_aida.properties

USER postgres
RUN /etc/init.d/postgresql start &&\
  psql --command "CREATE USER docker WITH SUPERUSER PASSWORD 'docker';" &&\
  createdb -O docker docker

USER root
RUN cd /
RUN bzcat AIDA_entity_repository_2010-08-17v7.sql.bz2 | psql aida
