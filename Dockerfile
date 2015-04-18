FROM debian:wheezy

ENV JAVA_VERSION 1.8.0

RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" \
      | tee /etc/apt/sources.list.d/webupd8team-java.list \
    &&  echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" \
      | tee -a /etc/apt/sources.list.d/webupd8team-java.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886 \
    && echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" \
        | /usr/bin/debconf-set-selections \
    && apt-get update \
    && apt-get install -y \
        oracle-java8-installer \
    && update-alternatives --display java \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

RUN apt-get install -y \
  git \
  maven

RUN git clone https://github.com/yago-naga/aida.git
RUN cd aida
RUN echo -e "dataAccess = dmap\nNumThreads = 1" >> settings/aida.properties
RUN mvn package

RUN export MAVEN_OPTS="-Xmx12G"
 
ENTRYPOINT ["mvn", "jetty:run"]
EXPOSE 8080
