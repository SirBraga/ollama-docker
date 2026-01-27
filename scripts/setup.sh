#!/bin/bash

# Script de setup para Ollama Docker
# Executa a configuração inicial e baixa o modelo LLaMA

set -e

echo "🚀 Iniciando setup do Ollama..."

# Verifica se Docker está instalado
if ! command -v docker &> /dev/null; then
    echo "❌ Docker não encontrado. Instale o Docker primeiro."
    exit 1
fi

# Verifica se docker-compose está disponível
if ! command -v docker compose &> /dev/null; then
    echo "❌ Docker Compose não encontrado."
    exit 1
fi

# Detecta se há GPU NVIDIA disponível
if command -v nvidia-smi &> /dev/null; then
    echo "✅ GPU NVIDIA detectada. Usando configuração com GPU."
    COMPOSE_FILE="docker-compose.yml"
else
    echo "⚠️  GPU NVIDIA não detectada. Usando configuração CPU only."
    COMPOSE_FILE="docker-compose.cpu.yml"
fi

# Sobe os containers
echo "📦 Subindo containers..."
docker compose -f "$COMPOSE_FILE" up -d

# Aguarda o Ollama iniciar
echo "⏳ Aguardando Ollama iniciar..."
sleep 10

# Baixa o modelo LLaMA
echo "📥 Baixando modelo LLaMA 3.2 (3B)..."
docker exec ollama ollama pull llama3.2

echo ""
echo "✅ Setup concluído!"
echo ""
echo "📍 Endpoints disponíveis:"
echo "   - API Ollama: http://localhost:11434"
echo "   - Web UI: http://localhost:3000"
echo ""
echo "💡 Comandos úteis:"
echo "   - Listar modelos: docker exec ollama ollama list"
echo "   - Rodar modelo: docker exec -it ollama ollama run llama3.2"
echo "   - Baixar outro modelo: docker exec ollama ollama pull <modelo>"
