# Use an official Maven image with OpenJDK
FROM maven:3.9.6-eclipse-temurin-17 AS build

# Set working directory
WORKDIR /app

# Copy source files
COPY . .

# Build the WAR file
RUN mvn clean package

# Use Tomcat as base image to run the app
FROM tomcat:10.1.18-jdk17-temurin

# Remove default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR file to Tomcat
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Expose the port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]