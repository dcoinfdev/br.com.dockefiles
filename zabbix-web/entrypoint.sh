#!/bin/bash
# Script de entrada para iniciar Zabbix server e Zabbix Agent

# Iniciar o servidor Zabbix
docker-entrypoint.sh zabbix_agentd -f