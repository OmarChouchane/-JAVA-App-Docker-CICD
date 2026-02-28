# Task Flows — Java, Docker, and GitHub Actions CI/CD

A production-oriented Spring Boot backend project demonstrating end-to-end CI/CD with GitHub Actions, Docker image publishing, and automated deployment to an Ubuntu server.

## Project Overview

This repository showcases a complete DevOps workflow around a Java 17 API application:

- Build and test with Maven
- Containerize using a multi-stage Dockerfile
- Push versioned and latest images to Docker Hub
- Deploy automatically to an EC2-hosted environment via SSH
- Run PostgreSQL with Docker Compose

The project is designed as a portfolio-ready implementation for demonstrating practical CI/CD engineering with Java services.

## Tech Stack

- Java 17
- Spring Boot 3
- Maven Wrapper (`mvnw`)
- PostgreSQL 17
- Docker + Docker Compose
- GitHub Actions
- Docker Hub
- JMeter (load test assets in `jmeter/`)

## Repository Structure

- `src/main/java` — application source code (auth, todo, category, security, etc.)
- `src/main/resources` — profile-based configuration
- `src/test/java` — unit/integration tests
- `.github/workflows/deploy.yml` — CI/CD pipeline definition
- `Dockerfile` — multi-stage build and runtime image
- `docker-compose.dev.yml` — deployment stack (app + database)
- `docker-compose.yml` — local PostgreSQL service
- `jmeter/` — performance test plans and input datasets

## CI/CD Pipeline (GitHub Actions)

The workflow executes on push and pull request events to `main`.

### 1) Test Job

- Checks out source code
- Configures JDK 17 (Corretto)
- Restores Maven dependency cache
- Runs `./mvnw clean test`

### 2) Build & Deploy Job (main only)

- Extracts project version from Maven
- Builds application artifact (`./mvnw clean package -DskipTests`)
- Builds and pushes Docker image with tags:
  - `latest`
  - `${project.version}`
- Connects to server via SSH and performs:
  - environment file generation from GitHub secrets
  - compose file refresh
  - image pull + rolling restart via Docker Compose

## Docker Build Notes

The Dockerfile uses a multi-stage strategy:

- **Build stage** compiles and packages the Spring Boot JAR
- **Runtime stage** runs a deterministic `/app/app.jar` file

This approach avoids runtime failures due to artifact naming differences.

## Environment Variables

Use `.env.example` as the baseline for local configuration.

For deployment, the pipeline injects runtime secrets through GitHub Actions secrets (database credentials, Docker Hub credentials, server SSH credentials).

## Local Run

### Prerequisites

- Java 17
- Docker + Docker Compose

### Start database

```bash
docker compose up -d
```

### Run API locally

```bash
./mvnw spring-boot:run -Dspring-boot.run.profiles=dev
```

## Publish-Ready DevOps Highlights

- Automated testing and build on each PR/push
- Docker image versioning strategy (`latest` + semantic project version)
- Layer caching with Buildx/GHA cache
- Automated remote deployment through secure SSH
- Clean separation of build and runtime concerns in container image

## Author

Omar Chouchane

If you are reviewing this repository from LinkedIn, this project is intended as a practical demonstration of Java backend delivery with CI/CD automation and container-based deployment.
