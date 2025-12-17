# Node Code (Python) - Deduplicação + Geração de SQL Blindada
# Nao requer bibliotecas externas, roda liso no n8n Cloud

# 1. Definição Rígida de Tipos (Quem ganha aspas e quem não ganha)
cols_config = {
    'SPRINT_NAME': 'text',
    'START_DATE': 'date',
    'END_DATE': 'date',
    'SPRINT_STATUS': 'text',
    'PK_FACT_BACKLOG': 'text',
    'JOB_NUMBER': 'text',
    'FW': 'text',
    'ITEM': 'text',
    'TASK': 'text',
    'CAT_TASK': 'text',
    'PRIORITY': 'number',  # Numerico: sem aspas
    'STATUS': 'text',
    'EMPLOYEE': 'text',
    'STARTTIME': 'date',
    'ENDTIME': 'date',
    'UPDATED_AT': 'date',
    'BEAD': 'text',
    'HEIGHT': 'number',  # Numerico
    'WIDTH': 'number',  # Numerico
    'FIXING': 'text',
    'FIXING_SIZE': 'text'
}


# 2. Função de Limpeza (Sanitize)
def get_sql_value(val, type_def):
    s_val = str(val).strip()

    # DETECTOR DE NULOS: Pega None, "null", "jsnull", etc.
    if val is None or s_val.lower() in ["", "null", "jsnull", "none", "[null]", "nan"]:
        return "NULL"

        # TRATAMENTO DE NÚMEROS
    if type_def == 'number':
        try:
            float(s_val)  # Testa se é numero
            return s_val  # Retorna sem aspas
        except:
            return "NULL"

    # TRATAMENTO DE DATAS
    if type_def == 'date':
        # Remove o 'T' e 'Z' do formato ISO
        clean_date = s_val.replace('T', ' ').replace('Z', '')
        return f"'{clean_date}'"

        # TRATAMENTO DE TEXTO (Escapa aspas simples)
    clean_str = s_val.replace("'", "''")
    return f"'{clean_str}'"


# --- ETAPA DE DEDUPLICAÇÃO ---
unique_rows = {}  # Dicionario para guardar apenas os unicos

for item in items:
    row = item.get('json', {})
    pk = row.get('PK_FACT_BACKLOG')  # A chave primaria

    # Se nao tiver PK, nao tem como garantir unicidade, entao ignoramos ou adicionamos com risco
    if not pk:
        continue

        # Logica de "Quem ganha?" (Prioriza ENDTIME, depois UPDATED_AT)
    current_date_score = row.get('ENDTIME') or row.get('UPDATED_AT') or ""

    # Se a PK ja existe, compara as datas (String ISO funciona para comparacao: 2025 > 2024)
    if pk in unique_rows:
        existing_row = unique_rows[pk]
        existing_date_score = existing_row.get('ENDTIME') or existing_row.get('UPDATED_AT') or ""

        # Se a linha atual for "maior" (mais nova) que a existente, substitui
        if str(current_date_score) > str(existing_date_score):
            unique_rows[pk] = row
    else:
        # Se é nova, adiciona
        unique_rows[pk] = row

# --- ETAPA DE GERAÇÃO DE SQL ---
output_items = []
cols_order = list(cols_config.keys())

# Agora iteramos apenas sobre as linhas unicas e limpas
for row in unique_rows.values():
    row_values = []

    for col in cols_order:
        val = row.get(col, None)
        type_def = cols_config[col]
        sql_val = get_sql_value(val, type_def)
        row_values.append(sql_val)

    cols_str = ",".join(cols_order)
    vals_str = ",".join(row_values)

    sql = f"INSERT INTO dbo.STAGING_FACT_SPRINT_TASKS ({cols_str}) VALUES ({vals_str})"

    output_items.append({"json": {"generated_sql": sql}})

print(f"Total original: {len(items)} | Total apos deduplicacao: {len(output_items)}")
return output_items