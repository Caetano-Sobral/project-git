-- Arquivo: database/azure_sql/merge_logic.sql
-- Objetivo: Sincronizar dados do Staging para a Fact sem duplicar (Upsert)

MERGE INTO dbo.FACT_SPRINT_TASKS AS tgt
USING dbo.STAGING_FACT_SPRINT_TASKS AS src
ON tgt.PK_FACT_BACKLOG = src.PK_FACT_BACKLOG

-- CENÁRIO 1: O registro já existe (UPDATE)
WHEN MATCHED THEN
  UPDATE SET
    SPRINT_NAME = src.SPRINT_NAME,
    START_DATE = src.START_DATE,
    END_DATE = src.END_DATE,
    SPRINT_STATUS = src.SPRINT_STATUS,
    JOB_NUMBER = src.JOB_NUMBER,
    FW = src.FW,
    ITEM = src.ITEM,
    TASK = src.TASK,
    CAT_TASK = src.CAT_TASK,
    PRIORITY = src.PRIORITY,
    EMPLOYEE = src.EMPLOYEE,
    STATUS = src.STATUS,
    STARTTIME = src.STARTTIME,

    -- Lógica de Preservação de Histórico:
    -- Se a tarefa já estava 'Complete', não mudamos a data de atualização
    UPDATED_AT = CASE
                    WHEN tgt.STATUS IN ('Complete','Not Required') THEN tgt.UPDATED_AT
                    ELSE src.UPDATED_AT
                 END,
    -- Só preenche a data de fim se ela estava vazia antes
    ENDTIME = CASE
                 WHEN tgt.ENDTIME IS NULL AND src.ENDTIME IS NOT NULL THEN src.ENDTIME
                 ELSE tgt.ENDTIME
              END,

    BEAD = src.BEAD,
    HEIGHT = src.HEIGHT,
    WIDTH = src.WIDTH,
    FIXING = src.FIXING,
    FIXING_SIZE = src.FIXING_SIZE

-- CENÁRIO 2: O registro é novo (INSERT)
WHEN NOT MATCHED BY TARGET THEN
  INSERT (
      PK_FACT_BACKLOG, SPRINT_NAME, START_DATE, END_DATE, SPRINT_STATUS,
      JOB_NUMBER, FW, ITEM, TASK, CAT_TASK, PRIORITY, STATUS, EMPLOYEE,
      STARTTIME, ENDTIME, UPDATED_AT, BEAD, HEIGHT, WIDTH, FIXING, FIXING_SIZE
  )
  VALUES (
      src.PK_FACT_BACKLOG, src.SPRINT_NAME, src.START_DATE, src.END_DATE, src.SPRINT_STATUS,
      src.JOB_NUMBER, src.FW, src.ITEM, src.TASK, src.CAT_TASK, src.PRIORITY, src.STATUS, src.EMPLOYEE,
      src.STARTTIME, src.ENDTIME,
      -- Se não tiver data de fim, usa a data de atualização como referência inicial
      CASE WHEN src.ENDTIME IS NOT NULL THEN src.ENDTIME ELSE src.UPDATED_AT END,
      src.BEAD, src.HEIGHT, src.WIDTH, src.FIXING, src.FIXING_SIZE
  );