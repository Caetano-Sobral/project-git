# 🏭 Ecossistema de Dados & BI - Caetano Sobral

Este repositório centraliza a infraestrutura de dados, automação e visualização da empresa. O projeto orquestra a extração de dados de produção (Oracle), transformação e carga (ETL via n8n) em um Data Warehouse (Azure SQL), alimentando o ecossistema de Power Platform.

## 🏗️ Arquitetura da Solução

O fluxo de dados segue a seguinte pipeline:

`Oracle Autonomous (Source)` ➡️ `n8n (Orchestrator/Python)` ➡️ `Azure SQL (Data Warehouse)` ➡️ `Power BI & Apps (Frontend)`

## 📂 Estrutura do Repositório

| Pasta | Descrição |
| :--- | :--- |
| **`workflows_n8n/`** | Backups dos fluxos de automação (JSON). Contém a lógica de ETL e integração. |
| **`database/`** | Scripts SQL essenciais. Inclui DDL (`structure.sql`) e lógica de MERGE (`merge_logic.sql`). |
| **`scripts/`** | Snippets de Python extraídos do n8n para documentação e versionamento de lógica complexa (ex: limpeza, fuso horário). |
| **`frontend_power_platform/`** | Arquivos binários de backup dos Dashboards (`.pbix`) e Aplicativos (`.msapp`/`.zip`). |
| **`infrastructure/`** | Documentação de servidores (VPS/VM) e configurações de ambiente (Docker). |
| **`ROADMAP.md`** | Lista de tarefas e melhorias planejadas para 2026. |

## 🛠️ Stack Tecnológica

* **Orquestração:** n8n (Self-hosted em VPS)
* **Linguagem de Script:** Python 3.x (Pandas, DateTime)
* **Banco de Dados:** Microsoft Azure SQL Server & Oracle Autonomous DB
* **Frontend:** Microsoft Power BI & Power Apps
* **Versionamento:** Git & GitHub

## 🔄 Como Restaurar / Utilizar

### 1. Banco de Dados
Para recriar a estrutura em um novo banco Azure SQL:
1.  Execute `database/azure_sql/structure.sql` para criar as tabelas (Staging e Fact).
2.  O script `merge_logic.sql` contém a query usada pelo n8n para upsert.

### 2. Automação (n8n)
1.  Importe o arquivo `.json` da pasta `workflows_n8n` para sua instância do n8n.
2.  Configure as credenciais (Oracle/Azure) no painel de credenciais do n8n (não versionadas aqui por segurança).

### 3. Power BI
1.  Baixe o arquivo `.pbix` da pasta `frontend_power_platform/power_bi`.
2.  Abra no Power BI Desktop e atualize as credenciais do Azure SQL.

---
*Mantido por Caetano Sobral.*