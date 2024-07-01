#!/bin/bash
# Script de entrada para iniciar Zabbix server e Zabbix Agent

# Iniciar o servidor Zabbix
docker-entrypoint.sh /usr/sbin/zabbix_server --foreground -c /etc/zabbix/zabbix_server.conf &

# Aguardar um momento para o servidor iniciar completamente (opcional)
sleep 5

# Iniciar o agente Zabbix
zabbix_agentd -f