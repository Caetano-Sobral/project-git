-- Arquivo: database/azure_sql/structure.sql
-- Objetivo: Recriar as tabelas do projeto (DDL)

-- 1. Tabela Definitiva (Onde o histórico e dados finais ficam)
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='FACT_SPRINT_TASKS' AND xtype='U')
CREATE TABLE dbo.FACT_SPRINT_TASKS (
    PK_FACT_BACKLOG varchar(255) NOT NULL PRIMARY KEY, -- Chave Primária definida
    SPRINT_NAME varchar(255),
    START_DATE datetime,
    END_DATE datetime,
    SPRINT_STATUS varchar(50),
    JOB_NUMBER varchar(50),
    FW varchar(50),
    ITEM varchar(50),
    TASK varchar(255),
    CAT_TASK varchar(100),
    PRIORITY varchar(50),
    EMPLOYEE varchar(100),
    STATUS varchar(50),
    STARTTIME datetime,
    ENDTIME datetime,
    UPDATED_AT datetime,
    BEAD varchar(50),
    HEIGHT float,
    WIDTH float,
    FIXING varchar(100),
    FIXING_SIZE varchar(50)
);

-- 2. Tabela de Staging (Palco temporário para carga bruta)
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='STAGING_FACT_SPRINT_TASKS' AND xtype='U')
CREATE TABLE dbo.STAGING_FACT_SPRINT_TASKS (
    PK_FACT_BACKLOG varchar(255), -- Staging não precisa de PK estrita, mas ajuda
    SPRINT_NAME varchar(255),
    START_DATE datetime,
    END_DATE datetime,
    SPRINT_STATUS varchar(50),
    JOB_NUMBER varchar(50),
    FW varchar(50),
    ITEM varchar(50),
    TASK varchar(255),
    CAT_TASK varchar(100),
    PRIORITY varchar(50),
    EMPLOYEE varchar(100),
    STATUS varchar(50),
    STARTTIME datetime,
    ENDTIME datetime,
    UPDATED_AT datetime,
    BEAD varchar(50),
    HEIGHT float,
    WIDTH float,
    FIXING varchar(100),
    FIXING_SIZE varchar(50)
);