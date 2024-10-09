# Build stage
FROM golang:1.22-alpine AS build-stage

# Set current working directory to /app
WORKDIR /app

# Copy all files from the current directory to the container /app
COPY . .

# Download all dependencies, so we can build our application
RUN go mod download

# Build the application binary
RUN CGO_ENABLED=0 GOOS=linux go build -o ./bin/satusehat-icd10-api  .

# Deploy the application binary
FROM alpine:3.13 AS build-stage-release

# Set current working directory to /app
WORKDIR /app

# Copy the application binary from the build stage to the current stage
COPY --from=build-stage /app/bin/satusehat-icd10-api .

# Expose port 8080 for the application
EXPOSE 8080

# Set the default command to run the application
CMD ["./satusehat-icd10-api"]
