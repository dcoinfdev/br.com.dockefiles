# Use a imagem base do MySQL 8.0.37-Debian
FROM mysql:8.0.37-bookworm

# Instale as dependências necessárias para o Zabbix Agent e o wget
RUN apt-get update \
    && apt-get install -y wget gnupg2 \
    && wget https://repo.zabbix.com/zabbix-official-repo.key \
    && apt-key add zabbix-official-repo.key \
    && echo "deb https://repo.zabbix.com/zabbix/6.5/debian bookworm main" > /etc/apt/sources.list.d/zabbix.list \
    && apt-get update \
    && apt-get install -y zabbix-agent \
    && rm -rf /var/lib/apt/lists/*

# Crie o diretório necessário para o PID do Zabbix Agent
RUN mkdir -p /var/run/zabbix && chown zabbix:zabbix /var/run/zabbix

# Copie o arquivo de configuração do Zabbix Agent para dentro do contêiner
COPY zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf

# Copie o script de entrada para o contêiner e defina permissões
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Exponha a porta padrão do Zabbix Agent
EXPOSE 10052

# Defina o script de entrada como o comando inicial
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]