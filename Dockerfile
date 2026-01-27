FROM ollama/ollama:latest

# Copia o script de entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expõe a porta padrão do Ollama
EXPOSE 11434

# Define o host para aceitar conexões externas
ENV OLLAMA_HOST=0.0.0.0

# Define o entrypoint customizado
ENTRYPOINT ["/entrypoint.sh"]
