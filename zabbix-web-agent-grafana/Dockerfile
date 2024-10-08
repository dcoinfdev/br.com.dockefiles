# Usar a imagem base existente do Zabbix Web
FROM dcoinfdev/zabbix-web:v1.0.0

# Manter informações do mantenedor
LABEL maintainer="Daniel Oliveira | Consultor de Tecnologia <daniel@dcoti.com.br>"

# Executar todos os comandos RUN como root
USER root

# Atualizar os pacotes e instalar dependências necessárias
RUN apt-get update && \
    apt-get install -y apt-transport-https software-properties-common wget gnupg2 && \
    wget -q -O - https://packages.grafana.com/gpg.key | apt-key add - && \
    add-apt-repository "deb https://packages.grafana.com/oss/deb stable main" && \
    apt-get update && \
    apt-get install -y grafana && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Criar diretório para armazenamento de dados do Grafana (opcional)
RUN mkdir -p /var/lib/grafana

# Expor as portas necessárias para o Zabbix Web e Grafana
EXPOSE 80 3000

# Copiar arquivo de configuração do Grafana (se necessário)
# COPY grafana.ini /etc/grafana/grafana.ini

# Instalar o supervisor para gerenciar múltiplos serviços
RUN apt-get update && \
    apt-get install -y supervisor && \
    mkdir -p /var/log/supervisor

# Adicionar arquivo de configuração do supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Definir o comando de inicialização para rodar o supervisor
CMD ["/usr/bin/supervisord"]

# Limpar os pacotes temporários para reduzir o tamanho da imagem final
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*