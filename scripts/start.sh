#!/bin/bash

# Inicia os containers do Ollama

# Detecta GPU
if command -v nvidia-smi &> /dev/null; then
    COMPOSE_FILE="docker-compose.yml"
else
    COMPOSE_FILE="docker-compose.cpu.yml"
fi

cd "$(dirname "$0")/.."
docker compose -f "$COMPOSE_FILE" up -d

echo "✅ Ollama iniciado!"
echo "   - API: http://localhost:11434"
echo "   - Web UI: http://localhost:3000"
