FROM alpine:latest

WORKDIR /app

# Instala dependências
RUN apk add --no-cache bash curl jq sqlite

# Copia o script Bash
COPY viaipe_collector.sh .

# Define permissões de execução
RUN chmod +x viaipe_collector.sh

# Executa o script em loop
CMD ["./viaipe_collector.sh"]
