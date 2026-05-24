FROM gradle:8.14.3-jdk21-alpine AS build
WORKDIR /app

COPY gradlew build.gradle settings.gradle ./
COPY gradle ./gradle
COPY src ./src

RUN chmod +x gradlew && ./gradlew clean bootJar --no-daemon

FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

RUN addgroup -S app && adduser -S app -G app

COPY --from=build /app/build/libs/*.jar /app/app.jar

EXPOSE 8080

ENV SERVER_PORT=8080

USER app

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
