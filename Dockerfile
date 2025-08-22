# ---------- Build stage ----------
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app

# Copy only pom first to cache dependencies
COPY pom.xml .
RUN mvn -B -q -DskipTests dependency:go-offline

# Now copy sources and build the fat jar (target/app.jar thanks to <finalName>app</finalName>)
COPY . .
RUN mvn -B -DskipTests clean package
RUN ls -lah target

# ---------- Run stage ----------
FROM eclipse-temurin:21-jre
WORKDIR /app

# Copy the JAR with a deterministic name
COPY --from=build /app/target/app.jar app.jar

# If Railway sets $PORT, Spring Boot can bind to it if you pass --server.port
# Otherwise it will default to 8080.
EXPOSE 8080
ENV JAVA_OPTS="-XX:MaxRAMPercentage=75.0 -XX:+UseG1GC"

# If Railway provides PORT, pass it through; otherwise run default.
ENTRYPOINT ["sh","-c","exec java $JAVA_OPTS -jar app.jar --server.port=${PORT:-8080}"]
