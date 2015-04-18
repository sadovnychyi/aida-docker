FROM debian:wheezy

# Install Java.
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

# Define working directory.
WORKDIR /data

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

RUN apt-get install -y \
  git \
  maven

RUN git clone https://github.com/yago-naga/aida.git
RUN cd aida
RUN mvn package
RUN echo -e "dataAccess = dmap\nNumThreads = 1" >> settings/aida.properties

RUN export MAVEN_OPTS="-Xmx12G"
 
ENTRYPOINT ["mvn", "jetty:run"]
EXPOSE 8080
