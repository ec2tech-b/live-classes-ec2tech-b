# stable official Java runtime base image
FROM openjdk:17-jdk-alpine

# metadata
LABEL maintainer="Akas Patranobis"
LABEL version="1.0"
LABEL description="A simple Java application"

# working directory
WORKDIR /usr/src/app/

# Copy source code into the container
COPY Main.java  /usr/src/app/

# Compile the Java code
RUN javac Main.java

# Run the Java application when the container starts
CMD ["java", "Main"]