### BUILD WAR
#FROM maven:3-jdk-11 as build
FROM maven:3.5-jdk-8-alpine as build

# Copy source code
COPY pom.xml pom.xml
COPY src src

# Build application
RUN mvn package

### BUILD TOMCAT
#FROM tomcat:8.0-alpine
FROM tomcat:8-jre8

LABEL maintainer="janusky@gmail.com"

# Copy war file from the build image
COPY --from=build /target/*.war /usr/local/tomcat/webapps/

# Enable remote debugging
#ENV JPDA_ADDRESS="8000"
#ENV JPDA_TRANSPORT="dt_socket"
#ENTRYPOINT ["catalina.sh", "jpda", "run"]

EXPOSE 8080

ENTRYPOINT ["catalina.sh", "run"]
