#!/bin/bash
set -e

# Inicia o servidor Ollama em background
/bin/ollama serve &

# Aguarda o servidor iniciar
echo "Aguardando Ollama iniciar..."
sleep 5

# Baixa os modelos especificados em OLLAMA_MODELS
if [ -n "$OLLAMA_MODELS" ]; then
    echo "Verificando modelos: $OLLAMA_MODELS"
    for model in $OLLAMA_MODELS; do
        if ! ollama list | grep -q "$model"; then
            echo "Baixando modelo: $model"
            ollama pull "$model"
        else
            echo "Modelo $model já existe"
        fi
    done
fi

# Mantém o container rodando
wait
