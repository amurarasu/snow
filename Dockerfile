FROM openjdk:8-jre-alpine

COPY build/libs/snow-app-0.0.1-SNAPSHOT.jar /opt/snow-app-0.0.1-SNAPSHOT.jar

EXPOSE 8761

CMD java -jar /opt/snow-app-0.0.1-SNAPSHOT.jar