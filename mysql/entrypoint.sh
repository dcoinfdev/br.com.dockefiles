#!/bin/bash
# Script de entrada para iniciar MySQL e Zabbix Agent

# Iniciar MySQL em segundo plano
docker-entrypoint.sh mysqld &

# Esperar alguns segundos para garantir que MySQL está ativo
sleep 10

# Iniciar Zabbix Agent
zabbix_agentd -f