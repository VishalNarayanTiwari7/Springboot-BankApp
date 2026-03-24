#----------------------------------
# Stage 1 (Builder)
#----------------------------------

FROM maven:3.8.3-openjdk-17 AS builder

WORKDIR /src

# ✅ Step 1: Copy only pom.xml (for caching dependencies)
COPY pom.xml .

RUN mvn dependency:go-offline

# ✅ Step 2: Copy remaining code
COPY . .

# ✅ Step 3: Build
RUN mvn clean package -DskipTests


#--------------------------------------
# Stage 2 (Runtime)
#--------------------------------------

FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

# Copy jar from builder
COPY --from=builder /src/target/*.jar /app/bankapp.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/bankapp.jar"]
