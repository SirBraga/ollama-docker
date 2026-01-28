# ⚡ Guia de Otimização de Performance - Ollama

## 🚀 Otimizações Aplicadas

### 1. **Docker Compose Otimizado**

```yaml
environment:
  - OLLAMA_NUM_PARALLEL=2              # Processa 2 requisições simultaneamente
  - OLLAMA_MAX_LOADED_MODELS=1         # Mantém apenas 1 modelo na RAM
  - OLLAMA_FLASH_ATTENTION=1           # Ativa Flash Attention (30-50% mais rápido)
  - OLLAMA_NUM_GPU=0                   # Força CPU
  - OLLAMA_NUM_THREAD=4                # 4 threads da CPU
  - OLLAMA_KEEP_ALIVE=5m               # Mantém modelo carregado por 5min

mem_limit: 6g                          # Limite de RAM
memswap_limit: 6g                      # Desabilita swap (evita lentidão)
cpu_count: 4                           # Usa 4 CPUs
shm_size: 2gb                          # Memória compartilhada
```

### 2. **O que cada otimização faz:**

| Configuração | O que faz | Impacto |
|--------------|-----------|---------|
| `OLLAMA_NUM_PARALLEL=2` | Processa 2 requisições ao mesmo tempo | ⚡⚡ Reduz fila |
| `OLLAMA_MAX_LOADED_MODELS=1` | Mantém só 1 modelo na RAM | 💾 Economiza memória |
| `OLLAMA_FLASH_ATTENTION=1` | Algoritmo mais rápido de atenção | ⚡⚡⚡ 30-50% mais rápido |
| `OLLAMA_NUM_THREAD=4` | Usa 4 threads da CPU | ⚡⚡ Usa CPU melhor |
| `OLLAMA_KEEP_ALIVE=5m` | Não descarrega modelo por 5min | ⚡⚡⚡ Evita reload |
| `mem_limit=6g` | Limita RAM a 6GB | 🛡️ Evita OOM kill |
| `memswap_limit=6g` | Desabilita swap | ⚡⚡⚡ Evita disco lento |
| `shm_size=2gb` | Memória compartilhada | ⚡ Comunicação rápida |

## 📊 Ganhos de Performance Esperados

### Antes das otimizações:
```
gemma2:2b → 10-15s
phi3 → 25-30s
llama3.2 → 40s+
```

### Depois das otimizações:
```
gemma2:2b → 5-8s ⚡ (40-50% mais rápido)
phi3 → 15-20s ⚡ (30-40% mais rápido)
llama3.2 → 25-30s ⚡ (25-35% mais rápido)
```

## 🔧 Como Aplicar

### 1. Atualizar configurações:

```bash
cd /Users/sirbraga/Documents/ollama-docker

# Copiar .env.example se não tiver .env
cp .env.example .env

# Editar .env e ajustar OLLAMA_THREADS conforme sua VPS
nano .env
```

### 2. Ajustar threads conforme sua VPS:

```env
# VPS com 2 vCPUs
OLLAMA_THREADS=2

# VPS com 4 vCPUs (recomendado)
OLLAMA_THREADS=4

# VPS com 8 vCPUs
OLLAMA_THREADS=6
```

### 3. Reiniciar containers:

```bash
docker-compose down
docker-compose up -d
```

### 4. Verificar logs:

```bash
docker logs -f ollama
```

## 🎯 Modelos Recomendados por Performance

### Para VPS com 7.7GB RAM:

| Modelo | RAM Usada | Velocidade | Qualidade | Recomendação |
|--------|-----------|------------|-----------|--------------|
| **gemma2:2b** | ~2GB | ⚡⚡⚡⚡⚡ 5-8s | ⭐⭐⭐⭐ | ✅ **MELHOR ESCOLHA** |
| **qwen2.5:1.5b** | ~1.5GB | ⚡⚡⚡⚡⚡ 3-5s | ⭐⭐⭐ | ✅ Mais rápido |
| **phi3:mini** | ~2.5GB | ⚡⚡⚡⚡ 10-15s | ⭐⭐⭐⭐ | ✅ Bom equilíbrio |
| **llama3.2:3b** | ~3GB | ⚡⚡⚡ 15-20s | ⭐⭐⭐⭐⭐ | ⚠️ Mais lento |
| **mistral:7b** | ~5GB | ⚡⚡ 30s+ | ⭐⭐⭐⭐⭐ | ❌ Muito lento |

### Trocar modelo:

```bash
# Baixar novo modelo
docker exec -it ollama ollama pull qwen2.5:1.5b

# Atualizar .env do bot
nano /Users/sirbraga/Documents/api-teste/.env
```

```env
OLLAMA_MODEL=qwen2.5:1.5b
```

## 🔥 Otimizações Adicionais

### 1. **Usar modelo quantizado menor:**

```bash
# Ao invés de gemma2:2b (Q4), use:
docker exec -it ollama ollama pull gemma2:2b-q2_k

# Ou use modelo ainda menor:
docker exec -it ollama ollama pull qwen2.5:0.5b
```

### 2. **Reduzir `num_predict` no código:**

Edite `ollama_ai.js`:

```javascript
options: {
    temperature: 0.8,
    top_p: 0.9,
    num_predict: 128,  // Reduzir de 256 para 128 (respostas mais curtas)
}
```

### 3. **Desabilitar busca web automática:**

Se a busca web está deixando lento, comente no `ollama_ai.js`:

```javascript
// Comentar detecção de busca web
// const searchMatch = assistantMessage.match(/\[BUSCAR:\s*(.+?)\]/i);
```

### 4. **Aumentar timeout se necessário:**

```javascript
}, {
    timeout: 90000  // Aumentar de 60s para 90s
});
```

## 📈 Monitoramento

### Ver uso de recursos:

```bash
# CPU e RAM do container
docker stats ollama

# Logs em tempo real
docker logs -f ollama

# Modelos carregados
docker exec -it ollama ollama ps
```

### Testar performance:

```bash
# Tempo de resposta
time curl http://localhost:11434/api/generate -d '{
  "model": "gemma2:2b",
  "prompt": "Olá, como você está?",
  "stream": false
}'
```

## 🛠️ Troubleshooting

### Container está usando muito swap:

```bash
# Verificar swap
free -h

# Reduzir mem_limit no docker-compose.yml
mem_limit: 4g  # Ao invés de 6g
```

### Respostas ainda lentas:

1. ✅ Trocar para modelo menor (`qwen2.5:1.5b` ou `qwen2.5:0.5b`)
2. ✅ Reduzir `num_predict` para 128 ou 64
3. ✅ Aumentar `OLLAMA_NUM_THREAD` se tiver mais vCPUs
4. ✅ Desabilitar busca web automática
5. ✅ Usar quantização Q2 ao invés de Q4

### Container morrendo (OOM):

```bash
# Reduzir mem_limit
mem_limit: 4g

# Ou usar modelo menor
OLLAMA_MODEL=qwen2.5:0.5b
```

## 🎯 Configuração Ideal para VPS 7.7GB RAM

```env
# .env do Ollama Docker
OLLAMA_MODELS=qwen2.5:1.5b
OLLAMA_THREADS=4
```

```env
# .env do Bot
OLLAMA_MODEL=qwen2.5:1.5b
```

```yaml
# docker-compose.yml
mem_limit: 5g
cpu_count: 4
```

```javascript
// ollama_ai.js
options: {
    temperature: 0.8,
    top_p: 0.9,
    num_predict: 128,  // Respostas curtas
}
```

**Resultado esperado:** 3-5s por resposta ⚡⚡⚡⚡⚡

## 📝 Checklist de Otimização

- [x] Flash Attention ativado
- [x] Limites de RAM configurados
- [x] Swap desabilitado
- [x] Threads da CPU otimizadas
- [x] Keep alive configurado
- [ ] Modelo menor instalado (qwen2.5:1.5b)
- [ ] num_predict reduzido (128)
- [ ] Testes de performance realizados

## 🚀 Próximos Passos

1. Reiniciar containers com novas configurações
2. Testar performance com `!ollama teste`
3. Se ainda lento, trocar para `qwen2.5:1.5b`
4. Monitorar com `docker stats ollama`
5. Ajustar conforme necessário
