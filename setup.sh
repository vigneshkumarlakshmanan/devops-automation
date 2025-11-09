#!/bin/bash
set -e

echo "=== Installing Docker & Docker Compose if missing ==="
if ! command -v docker &> /dev/null; then
    echo "Docker not found, please install Docker first!"
    exit 1
fi

if ! command -v docker compose &> /dev/null; then
    echo "Docker Compose not found, please install Docker Compose!"
    exit 1
fi

echo "=== Building and starting containers ==="
docker compose up -d --build

echo "=== Waiting for services to be healthy ==="
services=("jenkins" "redis" "sample-app" "nginx")
for service in "${services[@]}"; do
    echo "Waiting for $service to be healthy..."
    while [ "$(docker inspect --format='{{.State.Health.Status}}' $service 2>/dev/null)" != "healthy" ]; do
        sleep 5
    done
    echo "$service is healthy"
done

echo "=== All services are up and running! ==="
echo "Jenkins: http://localhost:8080"
echo "App: http://localhost:3000"
echo "Nginx: http://localhost"
echo "Redis port: 6379"
