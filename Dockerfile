FROM maven:latest as builder
WORKDIR /app
COPY . .

RUN ["mvn","clean","install","-DskipTests"]

FROM openjdk:latest
COPY --from=builder /app/target/spring-boot-mysql-0.0.1-SNAPSHOT.jar /usr/src/myapp/
WORKDIR /usr/src/myapp

ARG MYSQL_DB_HOST
ARG MYSQL_DB_PORT
ARG MYSQL_DB_USERNAME
ARG MYSQL_DB_PASSWORD
ARG MYSQL_DB_DNAME

ENV MYSQL_DB_HOST=${MYSQL_DB_HOST}
ENV MYSQL_DB_USERNAME=${MYSQL_DB_USERNAME}
ENV MYSQL_DB_PORT=${MYSQL_DB_PORT}
ENV MYSQL_DB_PASSWORD=${MYSQL_DB_PASSWORD}
ENV MYSQL_DB_DNAME=${MYSQL_DB_DNAME}

EXPOSE 8080

CMD ["java", "-jar","spring-boot-mysql-0.0.1-SNAPSHOT.jar"]