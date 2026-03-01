FROM maven:3.9.9-eclipse-temurin-17 AS build

WORKDIR /app

# Copy Maven descriptor and resolve dependencies first (better layer caching)
COPY pom.xml .
RUN mvn -B dependency:go-offline

# Copy the rest of the source and build the WAR
COPY src ./src
COPY WebContent ./WebContent

RUN mvn -B clean package


# --- Runtime image with Tomcat ---
FROM tomcat:9.0-jdk17-temurin

# Remove default ROOT app
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy built WAR as ROOT.war so the app runs at "/"
# Maven will produce: target/<artifactId>-<version>.war
COPY --from=build /app/target/shopping-cart-0.0.1-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

WORKDIR /usr/local/tomcat

# Expose default Tomcat port
EXPOSE 8080

# Environment-driven DB and mail configuration (to be wired into the app)
ENV DB_URL=jdbc:mysql://localhost:3306/shopping-cart \
    DB_USERNAME=root \
    DB_PASSWORD=root \
    MAILER_EMAIL=your_email \
    MAILER_PASSWORD=your_app_password_generated_from_email

CMD ["catalina.sh", "run"]

