FROM maven:latest as builder
WORKDIR /app
COPY . .

RUN ["mvn","clean","install","-DskipTests"]

FROM openjdk:latest
COPY --from=builder /app/target/spring-boot-mysql-0.0.1-SNAPSHOT.jar /usr/src/myapp/
WORKDIR /usr/src/myapp
EXPOSE 8080

CMD ["java", "-jar","spring-boot-mysql-0.0.1-SNAPSHOT.jar"]