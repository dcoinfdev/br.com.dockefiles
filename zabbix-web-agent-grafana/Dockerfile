# Usar a imagem base existente do Zabbix Web
FROM dcoinfdev/zabbix-web:v1.0.0

# Manter informações do mantenedor
LABEL maintainer="Daniel Oliveira | Consultor de Tecnologia <daniel@dcoti.com.br>"

# Atualizar os pacotes e instalar dependências necessárias
RUN apt-get update && apt-get install -y apt-transport-https software-properties-common wget

# Adicionar a chave GPG do repositório Grafana
RUN wget -q -O - https://packages.grafana.com/gpg.key | apt-key add -

# Adicionar o repositório Grafana
RUN add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"

# Atualizar novamente os pacotes e instalar Grafana
RUN apt-get update && apt-get install -y grafana

# Limpar os pacotes temporários
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Criar diretório para armazenamento de dados do Grafana (opcional)
RUN mkdir -p /var/lib/grafana

# Expor as portas necessárias para o Zabbix Web e Grafana
EXPOSE 80 3000

# Adicionar arquivo de configuração do supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Instalar o supervisor para gerenciar múltiplos serviços
RUN apt-get update && apt-get install -y supervisor && mkdir -p /var/log/supervisor

# Comando para iniciar o supervisor, que gerenciará ambos os serviços
CMD ["/usr/bin/supervisord"]

# Comandos de limpeza para reduzir o tamanho da imagem final
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
