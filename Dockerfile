# Use the Maven image to build the application
FROM maven:3.8.1-openjdk-17 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the pom.xml file and download the project dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy the rest of the application source code and build the application
COPY src ./src
RUN mvn clean package -DskipTests

# Use the Maven image as the runtime image
FROM maven:3.8.1-openjdk-17

WORKDIR /app

COPY --from=build /app/target/rihal-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
