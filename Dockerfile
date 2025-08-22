# --- Build stage ---
FROM maven:3.9.8-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn -ntp -q -DskipTests dependency:go-offline
COPY src ./src
RUN mvn -ntp -DskipTests package

# --- Run stage ---
FROM eclipse-temurin:21-jre
WORKDIR /app

ENV JAVA_TOOL_OPTIONS="-XX:MaxRAMPercentage=75"
COPY --from=build /app/target/*.jar app.jar
ENV PORT=8080
EXPOSE 8080
CMD ["java","-jar","/app/app.jar"]
