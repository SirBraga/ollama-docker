#!/bin/bash

# Para os containers do Ollama

cd "$(dirname "$0")/.."

# Detecta GPU
if command -v nvidia-smi &> /dev/null; then
    COMPOSE_FILE="docker-compose.yml"
else
    COMPOSE_FILE="docker-compose.cpu.yml"
fi

docker compose -f "$COMPOSE_FILE" down

echo "✅ Ollama parado!"
