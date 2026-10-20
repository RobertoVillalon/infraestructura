FROM amazoncorretto:25-alpine3.21 AS build

RUN apk add --no-cache maven

WORKDIR /app

COPY pom.xml ./
RUN mvn -B dependency:go-offline

COPY src ./src
RUN mvn -B clean package -DskipTests

FROM amazoncorretto:25-alpine3.21

WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8002

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
