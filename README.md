### Docker Compose File Documentation

#### Overview
Este arquivo `docker-compose.yml` define a configuração de um ambiente de monitoramento utilizando MySQL, Zabbix Server, Zabbix Web e Grafana. Ele segue a versão 3.8 do Compose e define quatro serviços principais, cada um com suas próprias configurações de imagem, rede, volumes e variáveis de ambiente.

#### Docker Compose Version
```yaml
version: '3.8'
```
- **`version: '3.8'`**: Define a versão do Docker Compose utilizada. A versão 3.8 é uma das mais recentes, oferecendo compatibilidade com recursos modernos do Docker.

#### Services

##### MySQL Service
```yaml
services:
  mysql:
    image: dcoinfdev/mysql-server:v1.0.0
    restart: always
    container_name: ${MYSQL_CONTAINER_NAME}
    ports:
      - "3306:3306"
    volumes:
      - ${MYSQL_DATA_PATH}:/var/lib/mysql
      - ${MYSQL_DATA_RUN}:/var/run/zabbix
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
    networks:
      zabbix-network:
        ipv4_address: 10.10.112.2
```
- **`image: dcoinfdev/mysql-server:v1.0.0`**: Utiliza uma imagem específica do MySQL personalizada.
- **`restart: always`**: Configura o contêiner para sempre reiniciar em caso de falha.
- **`container_name`**: Nome do contêiner definido por uma variável de ambiente.
- **`ports`**: Mapeia a porta 3306 do contêiner para a porta 3306 do host.
- **`volumes`**: Monta volumes para persistência de dados e logs.
  - `${MYSQL_DATA_PATH}:/var/lib/mysql`: Monta o diretório de dados do MySQL.
  - `${MYSQL_DATA_RUN}:/var/run/zabbix`: Monta o diretório de runtime do Zabbix.
- **`environment`**: Define variáveis de ambiente para configuração do MySQL.
- **`networks`**: Conecta o serviço à rede `zabbix-network` com um IP fixo.

##### Zabbix Server Service
```yaml
  zabbix-server:
    image: dcoinfdev/zabbix-server:v1.0.0
    restart: always
    container_name: ${ZABBIX_SERVER_CONTAINER_NAME}
    ports:
      - "10051:10051"
    volumes:
      - ${ZABBIX_SERVER_DATA_PATH}:/var/lib/zabbix
      - ${ZABBIX_SERVER_DATA_RUN}:/var/run/zabbix
      - ${ZABBIX_SERVER_DATA_LOG}:/var/log/zabbix
    environment:
      DB_SERVER_HOST: ${DB_SERVER_HOST}
      DB_SERVER_PORT: ${DB_SERVER_PORT}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
    depends_on:
      - mysql
    networks:
      zabbix-network:
        ipv4_address: 10.10.112.3
```
- **`image: dcoinfdev/zabbix-server:v1.0.0`**: Utiliza uma imagem específica do Zabbix Server personalizada.
- **`restart: always`**: Configura o contêiner para sempre reiniciar em caso de falha.
- **`container_name`**: Nome do contêiner definido por uma variável de ambiente.
- **`ports`**: Mapeia a porta 10051 do contêiner para a porta 10051 do host.
- **`volumes`**: Monta volumes para persistência de dados e logs.
  - `${ZABBIX_SERVER_DATA_PATH}:/var/lib/zabbix`: Monta o diretório de dados do Zabbix.
  - `${ZABBIX_SERVER_DATA_RUN}:/var/run/zabbix`: Monta o diretório de runtime do Zabbix.
  - `${ZABBIX_SERVER_DATA_LOG}:/var/log/zabbix`: Monta o diretório de logs do Zabbix.
- **`environment`**: Define variáveis de ambiente para configuração do Zabbix Server.
- **`depends_on`**: Garante que o contêiner do MySQL seja iniciado antes do Zabbix Server.
- **`networks`**: Conecta o serviço à rede `zabbix-network` com um IP fixo.

##### Zabbix Web Service
```yaml
  zabbix-web:
    image: dcoinfdev/zabbix-web:v1.0.0
    restart: always
    container_name: ${ZABBIX_WEB_CONTAINER_NAME}
    ports:
      - "8080:8080"
    volumes:
      - ${ZABBIX_WEB_DATA_PATH}:/usr/share/zabbix
      - ${ZABBIX_WEB_DATA_RUN}:/var/run/zabbix
      - ${ZABBIX_WEB_DATA_LOG}:/var/log/zabbixX
    environment:
      DB_SERVER_HOST: ${DB_SERVER_HOST}
      DB_SERVER_PORT: ${DB_SERVER_PORT}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      ZBX_SERVER_HOST: ${ZBX_SERVER_HOST}
      ZBX_SERVER_PORT: ${ZBX_SERVER_PORT}
      PHP_TZ: ${PHP_TZ}
    depends_on:
      - mysql
      - zabbix-server
    networks:
      zabbix-network:
        ipv4_address: 10.10.112.4
```
- **`image: dcoinfdev/zabbix-web:v1.0.0`**: Utiliza uma imagem específica do Zabbix Web personalizada.
- **`restart: always`**: Configura o contêiner para sempre reiniciar em caso de falha.
- **`container_name`**: Nome do contêiner definido por uma variável de ambiente.
- **`ports`**: Mapeia a porta 8080 do contêiner para a porta 8080 do host.
- **`volumes`**: Monta volumes para persistência de dados e logs.
  - `${ZABBIX_WEB_DATA_PATH}:/usr/share/zabbix`: Monta o diretório de dados do Zabbix Web.
  - `${ZABBIX_WEB_DATA_RUN}:/var/run/zabbix`: Monta o diretório de runtime do Zabbix.
  - `${ZABBIX_WEB_DATA_LOG}:/var/log/zabbixX`: Monta o diretório de logs do Zabbix.
- **`environment`**: Define variáveis de ambiente para configuração do Zabbix Web.
- **`depends_on`**: Garante que os contêineres do MySQL e do Zabbix Server sejam iniciados antes do Zabbix Web.
- **`networks`**: Conecta o serviço à rede `zabbix-network` com um IP fixo.

##### Grafana Service
```yaml
  grafana:
    image: grafana/grafana:latest
    restart: always
    container_name: ${GRAFANA_CONTAINER_NAME}
    ports:
      - "3000:3000"
    volumes:
      - ${GRAFANA_DATA_PATH}:/var/lib/grafana
    environment:
      GF_SECURITY_ADMIN_USER: ${GF_SECURITY_ADMIN_USER}
      GF_SECURITY_ADMIN_PASSWORD: ${GF_SECURITY_ADMIN_PASSWORD}
    networks:
      zabbix-network:
        ipv4_address: 10.10.112.5
```
- **`image: grafana/grafana:latest`**: Utiliza a imagem oficial mais recente do Grafana.
- **`restart: always`**: Configura o contêiner para sempre reiniciar em caso de falha.
- **`container_name`**: Nome do contêiner definido por uma variável de ambiente.
- **`ports`**: Mapeia a porta 3000 do contêiner para a porta 3000 do host.
- **`volumes`**: Monta volumes para persistência de dados.
  - `${GRAFANA_DATA_PATH}:/var/lib/grafana`: Monta o diretório de dados do Grafana.
- **`environment`**: Define variáveis de ambiente para configuração do Grafana.
- **`networks`**: Conecta o serviço à rede `zabbix-network` com um IP fixo.

#### Volumes
```yaml
volumes:
  mysql_data:
  zabbix_server_data:
  zabbix_web_data:
  grafana_data:
  openvpn-data:
  backups:
```
- **Definição de volumes**: Especifica volumes nomeados para persistência de dados dos serviços. Volumes não utilizados foram incluídos para futuras expansões ou uso específico.

#### Networks
```yaml
networks:
  zabbix-network:
    driver: bridge
    ipam:
      config:
        - subnet: 10.10.112.0/20
```
- **`zabbix-network`**: Define uma rede bridge chamada `zabbix-network` com uma configuração de IPAM especificando um subnet específico para controle de endereçamento IP.

### Considerações Finais
Este arquivo `docker-compose.yml` é projetado para configurar e orquestrar um ambiente completo de monitoramento usando MySQL, Zabbix

 e Grafana. Cada serviço é configurado para reiniciar automaticamente em caso de falha, garantindo alta disponibilidade. As variáveis de ambiente são usadas para tornar o arquivo flexível e reutilizável, permitindo fácil modificação das configurações sem alterar o arquivo diretamente.

- **MySQL**: Fornece o backend de banco de dados para os serviços Zabbix.
- **Zabbix Server**: Realiza a coleta e processamento de dados de monitoramento.
- **Zabbix Web**: Interface web para visualização e gerenciamento do Zabbix Server.
- **Grafana**: Ferramenta de visualização de dados que se integra com o Zabbix para criar dashboards avançados.

Ao seguir as melhores práticas de documentação e configuração, este arquivo `docker-compose.yml` é estruturado de maneira clara, eficiente e segura, facilitando a compreensão e manutenção do ambiente de monitoramento.
