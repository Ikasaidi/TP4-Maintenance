# Utiliser une image de base pour le build Maven
FROM maven:3.9.11-eclipse-temurin-17 AS build

# vos commandes de build ici
WORKDIR /build

COPY src/api/pom.xml .
RUN ["mvn", "dependency:resolve", "-U"]

COPY /src/api/src ./src
RUN ["mvn", "clean", "package", "-DskipTests"]

# Image finale pour l’excution
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
EXPOSE 8080

# vos commandes d’execution ici
COPY --from=build /build/target/*.jar /app/*.jar
ENTRYPOINT ["java", "-jar", "/app/*.jar"]