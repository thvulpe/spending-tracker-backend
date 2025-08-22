# ---------- Build (root project) ----------
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app

# Cache deps
COPY pom.xml .
RUN mvn -B -q -DskipTests dependency:go-offline

# Copy surse
COPY . .

# DEBUG: afișează clar versiunile (trebuie să fie 21)
RUN echo "=== TOOLCHAIN ===" \
 && java -version \
 && javac -version \
 && mvn -v

# Protecție: elimină override-uri de toolchain care te pot bloca pe 17
RUN rm -f .mvn/toolchains.xml .mvn/jvm.config || true

# Build curat; forțăm explicit release=21 ca să bată peste orice setare rătăcită
RUN mvn -B -e \
    -DskipTests -Dmaven.test.skip=true \
    -Dspotless.skip=true -Dcheckstyle.skip=true -Dpmd.skip=true -DskipITs=true \
    -Dmaven.compiler.release=21 -Djava.version=21 \
    clean package

# ---------- Run ----------
FROM eclipse-temurin:21-jre
WORKDIR /app
# ai <finalName>app</finalName> în pom -> target/app.jar
COPY --from=build /app/target/app.jar app.jar

EXPOSE 8080
ENTRYPOINT ["sh","-c","exec java -jar app.jar --server.port=${PORT:-8080}"]
