#!/bin/bash
set -e

# Inicia o servidor Ollama em background
/bin/ollama serve &
OLLAMA_PID=$!

# Aguarda o servidor iniciar
echo "Aguardando Ollama iniciar..."
sleep 10

# Baixa os modelos especificados em OLLAMA_MODELS
if [ -n "$OLLAMA_MODELS" ]; then
    echo "Verificando modelos: $OLLAMA_MODELS"
    echo "Modelos instalados:"
    ollama list || echo "Nenhum modelo instalado ainda"
    
    for model in $OLLAMA_MODELS; do
        if ollama list 2>/dev/null | grep -q "$model"; then
            echo "✓ Modelo $model já existe"
        else
            echo "⬇ Baixando modelo: $model"
            ollama pull "$model"
            echo "✓ Modelo $model baixado com sucesso"
        fi
    done
    
    echo ""
    echo "Modelos disponíveis:"
    ollama list
fi

# Mantém o container rodando
wait $OLLAMA_PID
