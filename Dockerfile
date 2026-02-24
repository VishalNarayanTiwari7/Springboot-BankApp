#----------------------------------
# Stage 1
#----------------------------------

FROM maven:3.8.3-openjdk-17 AS builder

LABEL app=bankapp

WORKDIR /src

COPY . /src

RUN mvn clean install -DskipTests=true


#--------------------------------------
# Stage 2
#--------------------------------------

FROM eclipse-temurin:17-jdk-alpine AS deployer

WORKDIR /src

COPY --from=builder /src/target/*.jar /src/target/bankapp.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/src/target/bankapp.jar"]
