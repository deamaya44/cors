FROM maven:3.9.9-amazoncorretto-17-alpine AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests


FROM maven:3.9.9-amazoncorretto-17-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENV SPRING_DATASOURCE_URL=jdbc:postgresql://172.25.251.204:5432/backend_db
ENTRYPOINT ["java", "-jar", "app.jar"]