<h1>Viaip Monitor</h1>

<p>
  O ViaIP Monitor é uma solução de monitoramento projetada para coletar métricas de uso de recursos (como logs e uso máximo de CPU/memória) e exibi-las em painéis (dashboards) no Grafana. O sistema é containerizado com Docker, facilitando a implantação e o gerenciamento.
</p>

<h2>Visão Geral</h2>
<p>O projeto consiste em dois componentes principais:</p>
<ul>
  <li>
    <strong>Agente de Coleta (viaipe-agent):</strong>
    <ul>
      <li>Coleta métricas de uso de recursos (logs, uso máximo de CPU/memória, etc.) por meio de um script Bash (<code>viaipe_collector.sh</code>).</li>
      <li>Armazena os dados coletados em um banco de dados SQLite (<code>monitoramento.db</code>).</li>
    </ul>
  </li>
  <li>
    <strong>Grafana:</strong>
    <ul>
      <li>Exibe os dados coletados em painéis (dashboards) personalizados.</li>
      <li>Configuração automatizada por meio de arquivos de provisionamento (<code>datasource.yml</code> e <code>viaipe.json</code>).</li>
    </ul>
  </li>
</ul>
<p>
  O sistema é orquestrado usando <code>docker-compose</code>, permitindo a execução integrada de todos os componentes.
</p>

<h2>Estrutura do Projeto</h2>
<pre>
viaip-monitor/
├── database
│   └── monitoramento.db        # Banco de dados SQLite para armazenar métricas
├── docker-compose.yml          # Configuração do Docker Compose para orquestração
├── grafana
│   └── provisioning
│       ├── dashboards
│       │   ├── ViaIpe - coleta de logs.png          # Print do painel de logs
│       │   ├── ViaIpe - coleta_max_usage.png          # Print do painel de uso máximo
│       │   └── viaipe.json                           # Definição do painel no Grafana
│       └── datasources
│           └── datasource.yml  # Configuração da fonte de dados do Grafana
├── README.md                   # Documentação do projeto
└── viaipe-agent
    ├── Dockerfile              # Dockerfile para o agente de coleta
    └── viaipe_collector.sh     # Script de coleta de métricas
</pre>

<h2>Como Executar o Projeto</h2>
<h3>Pré-requisitos</h3>
<ul>
  <li>Docker e Docker Compose instalados.</li>
  <li>Acesso à internet para baixar as imagens Docker.</li>
</ul>

<h3>Passos para Execução</h3>
<p><strong>Clone o repositório:</strong></p>
<pre>
git clone https://github.com/jcesar9100/viaip-monitor.git
cd viaip-monitor
</pre>

<p><strong>Inicie os containers com Docker Compose:</strong></p>
<pre>
docker-compose up -d
</pre>

<p><strong>Acesse o Grafana:</strong></p>
<ul>
  <li>Abra o navegador e acesse <a href="http://localhost:3000" target="_blank">http://localhost:3000</a>.</li>
  <li>Use as credenciais padrão (<code>admin/admin</code>) ou as configuradas no <code>docker-compose.yml</code>.</li>
</ul>

<p><strong>Verifique os painéis:</strong></p>
<p>
  Os painéis "ViaIpe - coleta de logs" e "ViaIpe - coleta_max_usage" já estarão configurados para exibir os dados coletados.
</p>

<h2>Configuração dos Componentes</h2>
<h3>Agente de Coleta (viaipe-agent)</h3>
<ul>
  <li><strong>Script de Coleta:</strong> O script <code>viaipe_collector.sh</code> é responsável por coletar métricas de uso de recursos.</li>
  <li><strong>Armazenamento:</strong> Os dados coletados são armazenados no banco de dados SQLite (<code>monitoramento.db</code>).</li>
  <li><strong>Dockerfile:</strong> O Dockerfile define a imagem Docker para o agente de coleta.</li>
</ul>

<h3>Grafana</h3>
<ul>
  <li><strong>Datasource:</strong> O arquivo <code>datasource.yml</code> configura a conexão com o banco de dados SQLite.</li>
  <li><strong>Dashboards:</strong> O arquivo <code>viaipe.json</code> define os painéis no Grafana, e os arquivos <code>.png</code> são prints dos painéis para referência.</li>
</ul>

<h3>Banco de Dados SQLite</h3>
<ul>
  <li><strong>Função:</strong> Armazena os dados coletados pelo agente.</li>
  <li><strong>Localização:</strong> <code>database/monitoramento.db</code>.</li>
</ul>

<h2>Exemplo de Uso</h2>
<p>
  Após iniciar os containers, o agente de coleta começará a coletar métricas automaticamente.
</p>
<p>
  Acesse o Grafana em <a href="http://localhost:3000" target="_blank">http://localhost:3000</a> e visualize os painéis:
</p>
<ul>
  <li><strong>ViaIpe - coleta de logs:</strong> Exibe logs coletados pelo agente.</li>
  <li><strong>ViaIpe - coleta_max_usage:</strong> Exibe o uso máximo de CPU/memória.</li>
</ul>
