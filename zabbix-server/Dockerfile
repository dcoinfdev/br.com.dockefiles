# Use a imagem base do Zabbix Server com MySQL e Ubuntu 20.04 LTS
FROM zabbix/zabbix-server-mysql:ubuntu-6.4-latest

# Definir o usuário root temporariamente para instalações
USER root

# Atualizar o sistema e instalar pacotes adicionais, incluindo o agente Zabbix
RUN apt-get update \
    && apt-get install -y zabbix-agent \
    && rm -rf /var/lib/apt/lists/*

# Crie o diretório necessário para o PID do Zabbix Agent
RUN mkdir -p /var/run/zabbix && chown zabbix:zabbix /var/run/zabbix \
    && mkdir -p /var/log/zabbix && chown -R zabbix:zabbix /var/log/zabbix 

# Copie o arquivo de configuração do Zabbix Agent para dentro do contêiner
COPY zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf

# Copie o script de entrada para o contêiner e defina permissões
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Remover privilégios de root e voltar ao usuário padrão
USER 1997

# Expor portas, se necessário (por exemplo, para o agente Zabbix)
EXPOSE 10050
EXPOSE 10051
EXPOSE 10052

# Iniciar o serviço do agente Zabbix
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]