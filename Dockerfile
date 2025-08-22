# ---------- Build stage ----------
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app

# Leverage Docker layer caching for dependencies
COPY pom.xml .
# Pre-fetch dependencies (no sources yet)
RUN mvn -B -q -DskipTests dependency:go-offline

# Now copy the rest and build
COPY . .
# Use the wrapper if you prefer; the Maven image already has mvn.
# RUN ./mvnw -B -DskipTests clean package
RUN mvn -B -DskipTests clean package

# ---------- Run stage ----------
FROM eclipse-temurin:21-jre
WORKDIR /app

# Copy the fat jar produced by Spring Boot
# Adjust if your artifactId/version differ or if you use a classifier
COPY --from=build /app/target/*-SNAPSHOT.jar app.jar

# Expose the port your app listens on (align with server.port if changed)
EXPOSE 8080

# JVM options can be tuned for Railway (small containers)
ENV JAVA_OPTS="-XX:MaxRAMPercentage=75.0 -XX:+UseG1GC"
ENTRYPOINT ["sh","-c","exec java $JAVA_OPTS -jar app.jar"]
