# 🦙 Ollama Docker - LLaMA na VPS

Deploy do Ollama com LLaMA usando Docker para sua VPS.

## 📋 Pré-requisitos

- Docker e Docker Compose instalados
- Mínimo 8GB RAM (recomendado 16GB+ para modelos maiores)
- GPU NVIDIA (opcional, mas recomendado para performance)

## 🚀 Quick Start

### 1. Clone/Copie para sua VPS

```bash
scp -r ollama-docker user@sua-vps:/home/user/
```

### 2. Execute o setup

```bash
cd ollama-docker
chmod +x scripts/*.sh
./scripts/setup.sh
```

O script detecta automaticamente se há GPU disponível.

## 📁 Estrutura

```
ollama-docker/
├── docker-compose.yml      # Config com GPU NVIDIA
├── docker-compose.cpu.yml  # Config CPU only
├── scripts/
│   ├── setup.sh           # Setup inicial
│   ├── start.sh           # Iniciar containers
│   ├── stop.sh            # Parar containers
│   ├── pull-model.sh      # Baixar modelos
│   └── logs.sh            # Ver logs
└── README.md
```

## 🎯 Endpoints

| Serviço | URL | Descrição |
|---------|-----|-----------|
| Ollama API | `http://localhost:11434` | API REST do Ollama |
| Open WebUI | `http://localhost:3000` | Interface web (ChatGPT-like) |

## 💻 Comandos Úteis

### Gerenciar Containers

```bash
# Iniciar
./scripts/start.sh

# Parar
./scripts/stop.sh

# Ver logs
./scripts/logs.sh
```

### Gerenciar Modelos

```bash
# Listar modelos instalados
docker exec ollama ollama list

# Baixar novo modelo
./scripts/pull-model.sh llama3.2
./scripts/pull-model.sh codellama
./scripts/pull-model.sh mistral

# Chat direto no terminal
docker exec -it ollama ollama run llama3.2
```

## 🔧 Modelos Recomendados

| Modelo | Tamanho | RAM Mínima | Uso |
|--------|---------|------------|-----|
| `llama3.2` | 2GB | 8GB | Chat geral |
| `llama3.2:1b` | 1.3GB | 4GB | Leve, rápido |
| `llama3.1:8b` | 4.7GB | 16GB | Mais capaz |
| `codellama` | 3.8GB | 16GB | Código |
| `mistral` | 4.1GB | 16GB | Alternativa |

## 🌐 API REST

### Chat Completion

```bash
curl http://localhost:11434/api/chat -d '{
  "model": "llama3.2",
  "messages": [
    { "role": "user", "content": "Olá, como você está?" }
  ]
}'
```

### Generate (streaming)

```bash
curl http://localhost:11434/api/generate -d '{
  "model": "llama3.2",
  "prompt": "Explique Docker em 3 frases"
}'
```

### Listar Modelos

```bash
curl http://localhost:11434/api/tags
```

## 🔒 Segurança na VPS

### Firewall (UFW)

```bash
# Permitir apenas acesso local ou via reverse proxy
sudo ufw deny 11434
sudo ufw deny 3000

# Ou permitir de IP específico
sudo ufw allow from SEU_IP to any port 3000
```

### Nginx Reverse Proxy (opcional)

```nginx
server {
    listen 80;
    server_name ollama.seudominio.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

## 🐛 Troubleshooting

### Container não inicia com GPU

```bash
# Verifique se nvidia-container-toolkit está instalado
nvidia-smi
docker run --rm --gpus all nvidia/cuda:12.0-base nvidia-smi

# Se não funcionar, use a versão CPU
docker compose -f docker-compose.cpu.yml up -d
```

### Modelo muito lento

- Verifique RAM disponível: `free -h`
- Use modelo menor: `llama3.2:1b`
- Adicione swap se necessário

### Erro de memória

```bash
# Aumentar swap
sudo fallocate -l 8G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

## 📚 Recursos

- [Ollama Docs](https://ollama.ai)
- [Ollama Models](https://ollama.ai/library)
- [Open WebUI](https://github.com/open-webui/open-webui)
