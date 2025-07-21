# Use Maven to build the application
FROM maven:3.9.6-eclipse-temurin-22-alpine AS build

WORKDIR /app

# Copy pom.xml and download dependencies first (for caching)
COPY pom.xml .
COPY .mvn .mvn
COPY mvnw .
RUN ./mvnw dependency:go-offline

# Copy source and build
COPY src ./src
RUN ./mvnw package -DskipTests

# Final image using JDK only
FROM eclipse-temurin:22-jdk-alpine

WORKDIR /app

# Copy jar from build stage
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
