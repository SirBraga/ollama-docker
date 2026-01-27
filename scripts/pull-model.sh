#!/bin/bash

# Script para baixar modelos no Ollama
# Uso: ./pull-model.sh <nome-do-modelo>

MODEL=${1:-llama3.2}

echo "📥 Baixando modelo: $MODEL"
docker exec ollama ollama pull "$MODEL"

echo "✅ Modelo $MODEL baixado com sucesso!"
echo ""
echo "Para usar: docker exec -it ollama ollama run $MODEL"
