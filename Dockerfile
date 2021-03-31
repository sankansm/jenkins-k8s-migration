FROM jenkins/slave:latest

COPY jenkins-slave /usr/local/bin/jenkins-slave

USER root

# Install Maven

ENV MAVEN_VERSION=3.5.4
ENV MAVEN_HOME=/opt/mvn

# change to tmp folder
WORKDIR /tmp
ADD settings.xml /home/jenkins/.m2/settings.xml
RUN chmod 777 /home/jenkins/.m2/

# Download and extract maven to opt folder
RUN wget --no-check-certificate --no-cookies http://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && wget --no-check-certificate --no-cookies http://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz.md5 \
    && echo "$(cat apache-maven-${MAVEN_VERSION}-bin.tar.gz.md5) apache-maven-${MAVEN_VERSION}-bin.tar.gz" | md5sum -c \
    && tar -zvxf apache-maven-${MAVEN_VERSION}-bin.tar.gz -C /opt/ \
    && ln -s /opt/apache-maven-${MAVEN_VERSION} /opt/mvn \
    && rm -f apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && rm -f apache-maven-${MAVEN_VERSION}-bin.tar.gz.md5

RUN apt-get update -qq \
    && apt-get install -qqy apt-transport-https ca-certificates curl gnupg2 software-properties-common 
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
RUN apt-get update  -qq \
    && apt-get install docker-ce=17.12.1~ce-0~debian -y
#RUN service docker start
VOLUME /var/run/docker.sock
#RUN chmod 777 /var/run/docker.sock
#VOLUME /var/run/docker.sock
#RUN chmod 777 /var/run/docker.sock
RUN usermod -aG docker jenkins
ENV DOCKER_HOST=tcp://127.0.0.1:4243
# add executables to path
RUN update-alternatives --install "/usr/bin/mvn" "mvn" "/opt/mvn/bin/mvn" 1 && \
    update-alternatives --set "mvn" "/opt/mvn/bin/mvn"
RUN chown jenkins:root /home/jenkins/.m2
USER jenkins
WORKDIR /home/jenkins

ENTRYPOINT ["jenkins-slave"]
