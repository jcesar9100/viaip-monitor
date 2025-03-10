#!/bin/bash

# Caminho do banco de dados SQLite
DB_PATH="/database/monitoramento.db"

# Cria a tabela se não existir (com a estrutura correta)
sqlite3 "$DB_PATH" "CREATE TABLE IF NOT EXISTS viaipe_stats (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    location_name TEXT NOT NULL,
    interface_name TEXT NOT NULL,
    availability REAL,          -- Disponibilidade média (%)
    bandwidth_usage REAL,       -- Consumo de banda média (KB/s)
    quality TEXT                -- Qualidade (Excelente, Boa, Ruim)
);"

# Função para calcular a disponibilidade média
calculate_availability() {
    local total=$1
    local available=$2
    echo "scale=2; $available / $total * 100" | bc
}

# Função para calcular o consumo de banda média
calculate_bandwidth_usage() {
    local total_bytes=$1
    local duration=$2
    echo "scale=2; $total_bytes / $duration / 1024" | bc  # Resultado em KB/s
}

# Função para avaliar a qualidade
evaluate_quality() {
    local availability=$1
    if (( $(echo "$availability >= 99" | bc -l) )); then
        echo "Excelente"
    elif (( $(echo "$availability >= 95" | bc -l) )); then
        echo "Boa"
    else
        echo "Ruim"
    fi
}

# Coleta dados da API
response=$(curl -s "https://viaipe.rnp.br/api/norte")

# Processa o JSON com jq
echo "$response" | jq -c '.[]' | while read -r item; do
    location_name=$(echo "$item" | jq -r '.name')
    interfaces=$(echo "$item" | jq -c '.data.interfaces[]')
    echo "$interfaces" | while read -r iface; do
        interface_name=$(echo "$iface" | jq -r '.nome')

        # Extrai os dados necessários para as métricas
        total=$(echo "$iface" | jq -r '.max_traffic_up')  # Total de tráfego possível
        available=$(echo "$iface" | jq -r '.traffic_out')  # Tráfego utilizado
        total_bytes=$(echo "$iface" | jq -r '.max_out')    # Total de bytes transmitidos
        duration=60  # Duração fixa de 60 segundos (ajuste conforme necessário)

        # Calcula as métricas
        availability=$(calculate_availability "$total" "$available")
        bandwidth_usage=$(calculate_bandwidth_usage "$total_bytes" "$duration")
        quality=$(evaluate_quality "$availability")

        # Insere os dados no banco de dados
        sqlite3 "$DB_PATH" "INSERT INTO viaipe_stats (location_name, interface_name, availability, bandwidth_usage, quality) VALUES ('$location_name', '$interface_name', $availability, $bandwidth_usage, '$quality');"
        echo "Dados inseridos: Location: $location_name, Interface: $interface_name, Availability: $availability%, Bandwidth Usage: $bandwidth_usage KB/s, Quality: $quality"
    done
done
