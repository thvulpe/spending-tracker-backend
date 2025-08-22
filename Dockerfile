# ---------- Build ----------
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app

COPY pom.xml .
RUN mvn -B -q -DskipTests dependency:go-offline

COPY . .
# show versions to confirm JDK 21
RUN java -version && javac -version && mvn -v

# build fat jar -> target/app.jar (requires <finalName>app</finalName> in pom)
RUN mvn -B -DskipTests clean package
RUN ls -lah target

# ---------- Run ----------
FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /app/target/app.jar app.jar
EXPOSE 8080
ENTRYPOINT ["sh","-c","exec java -jar app.jar --server.port=${PORT:-8080}"]
