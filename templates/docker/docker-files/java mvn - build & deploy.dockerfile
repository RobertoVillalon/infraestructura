ARG BASE_IMAGE=amazoncorretto:25-alpine3.20
ARG PORT

FROM ${BASE_IMAGE} AS build

RUN apk add --no-cache maven

WORKDIR /app

COPY pom.xml ./
RUN mvn -B dependency:go-offline

COPY src ./src
RUN mvn -B clean package -DskipTests

FROM ${BASE_IMAGE}

WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE ${PORT}

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
