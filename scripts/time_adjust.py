from datetime import datetime, timedelta, timezone

# Fuso horário fixo de Sydney (UTC+11 durante verão / UTC+10 durante inverno)
# ATENÇÃO: Ajuste manualmente para 10 quando o horário de verão acabar em Abril
SYDNEY_OFFSET = timezone(timedelta(hours=11))

processed_items = []

for item in _input.all():
    row = item.json

    if row.get('UPDATEDAT_AZURE'):
        try:
            dt_str = str(row.get('UPDATEDAT_AZURE')).replace('Z', '')
            dt = datetime.fromisoformat(dt_str)
            # Assume que a entrada é UTC e converte para Sydney (+11h)
            if dt.tzinfo is None:
                dt = dt.replace(tzinfo=timezone.utc)
            row['UPDATEDAT_AZURE'] = dt.astimezone(SYDNEY_OFFSET).isoformat()
        except:
            pass
    else:
        # Hora atual com offset fixo
        row['UPDATEDAT_AZURE'] = datetime.now(SYDNEY_OFFSET).isoformat()

    # Sanitização simples
    clean_row = {k: (None if v == '' or v is None else v) for k, v in row.items()}
    processed_items.append({"json": clean_row})

return processed_items