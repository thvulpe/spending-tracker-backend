# ---------- Build stage ----------
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app

# Cache deps
COPY pom.xml .
RUN mvn -B -q -DskipTests dependency:go-offline

# Build
COPY . .
RUN mvn -B -DskipTests clean package
RUN ls -lah target  # should show app.jar

# ---------- Run stage ----------
FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /app/target/app.jar app.jar

# Railway usually sets $PORT
EXPOSE 8080
ENTRYPOINT ["sh","-c","exec java -jar app.jar --server.port=${PORT:-8080}"]
