# Build stage
FROM eclipse-temurin:17-jdk AS build

WORKDIR /app
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
COPY src src

RUN chmod +x ./mvnw
RUN ./mvnw clean package -DskipTests
RUN JAR_FILE=$(ls /app/target/*.jar | grep -v '\.original$' | head -n 1) && cp "$JAR_FILE" /app/app.jar

# Runtime stage
FROM eclipse-temurin:17-jdk-jammy
ARG PROFILE=dev

WORKDIR /app
COPY --from=build /app/app.jar /app/app.jar

EXPOSE 8080

ENV DB_URL=jdbc:postgres://postgres-sql-spring-app:5432/spring_app_db

ENV ACTIVE_PROFILE=${PROFILE} 

CMD java -jar -Dspring.profiles.active=${ACTIVE_PROFILE} /app/app.jar