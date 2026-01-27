FROM ollama/ollama:latest

# Expõe a porta padrão do Ollama
EXPOSE 11434

# Define o host para aceitar conexões externas
ENV OLLAMA_HOST=0.0.0.0
