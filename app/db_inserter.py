import os
import sys
import pandas as pd
import mysql.connector
from dotenv import load_dotenv
from datetime import datetime

# ----------------------------------------------------------------
# Resolve o caminho do .env:
#   - Como .exe  → .env fica na mesma pasta do executável
#   - Como .py   → .env fica na raiz do projeto (um nível acima de app/)
# ----------------------------------------------------------------
if getattr(sys, 'frozen', False):
    _base_dir = os.path.dirname(sys.executable)
else:
    _base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

load_dotenv(os.path.join(_base_dir, '.env'))

# ----------------------------------------------------------------
# SQL de inserção
# ON DUPLICATE KEY UPDATE garante que se o mesmo (pin + code) já
# existir (quando houver UNIQUE INDEX), apenas atualiza em vez de
# duplicar. Sem o índice, se comporta como INSERT normal.
# ----------------------------------------------------------------
_INSERT_SQL = """
    INSERT INTO tb_EquipmentOptions
        (pin, code, description, created_at, created_by,
         deleted_at, deleted_by, created_at_db, updated_at)
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
    ON DUPLICATE KEY UPDATE
        description = VALUES(description),
        deleted_at  = VALUES(deleted_at),
        deleted_by  = VALUES(deleted_by),
        updated_at  = VALUES(updated_at)
"""


def _val(v):
    """Converte valor para string ou None se vazio/nulo."""
    try:
        if pd.isna(v):
            return None
    except (TypeError, ValueError):
        pass
    s = str(v).strip()
    if s.lower() in ('', 'nan', 'nat', 'none'):
        return None
    return s


def inserir_no_banco(df, log_fn=print):
    """
    Recebe um DataFrame consolidado com os dados extraídos da API JD
    e insere/atualiza os registros na tabela tb_EquipmentOptions.

    Retorna o número de linhas processadas.
    Lança exceção em caso de erro de conexão ou SQL.
    """
    host     = os.getenv("DB_HOST")
    port     = int(os.getenv("DB_PORT", "3306"))
    user     = os.getenv("DB_USER")
    password = os.getenv("DB_PASSWORD")
    database = os.getenv("DB_NAME")

    if not all([host, user, password, database]):
        raise ValueError(
            "Credenciais do banco incompletas.\n"
            "Verifique o arquivo .env e preencha:\n"
            "DB_HOST, DB_PORT, DB_USER, DB_PASSWORD, DB_NAME"
        )

    # Normaliza colunas do DataFrame para comparação segura
    df = df.copy()
    df.columns = [str(c).lower().strip() for c in df.columns]

    agora = datetime.now()

    conn = mysql.connector.connect(
        host=host,
        port=port,
        user=user,
        password=password,
        database=database,
        connect_timeout=10,
    )
    cursor = conn.cursor()
    inseridos = 0

    try:
        for _, row in df.iterrows():
            vals = (
                _val(row.get("pin")),
                _val(row.get("code")),
                _val(row.get("description")),
                _val(row.get("created")),
                _val(row.get("created by")),
                _val(row.get("deleted")),
                _val(row.get("deleted by")),
                agora,
                agora,
            )
            cursor.execute(_INSERT_SQL, vals)
            inseridos += 1

        conn.commit()
        log_fn(f"  DB: {inseridos} linhas inseridas/atualizadas com sucesso.")

    except Exception:
        conn.rollback()
        raise

    finally:
        cursor.close()
        conn.close()

    return inseridos
