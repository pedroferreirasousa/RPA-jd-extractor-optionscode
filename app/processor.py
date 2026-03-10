import pandas as pd
import requests
import io
import os
import traceback

# Log file vai para o Desktop do usuário
LOG_PATH = os.path.join(os.path.expanduser("~"), "Desktop", "jd_extractor_log.txt")

def _log(msg):
    """Grava mensagem no arquivo de log e imprime no console."""
    print(msg)
    try:
        with open(LOG_PATH, "a", encoding="utf-8") as f:
            f.write(msg + "\n")
    except Exception:
        pass

def processar_chassis(lista_path, token, caminho_saida):
    _log(f"=== Iniciando processamento ===")
    _log(f"Planilha: {lista_path}")
    _log(f"Destino: {caminho_saida}")
    try:
        # Lê a planilha selecionada pelo usuário
        df_lista = pd.read_excel(lista_path, engine='openpyxl')
        
        # Normaliza colunas (remove espaços e deixa minusculo)
        df_lista.columns = [str(c).lower().strip() for c in df_lista.columns]
        
        _log(f"Colunas encontradas: {list(df_lista.columns)}")

        if 'chassi' not in df_lista.columns:
            _log(f"Erro: Coluna 'chassi' não encontrada. Colunas disponíveis: {list(df_lista.columns)}")
            return None, f"Coluna 'chassi' não encontrada.\nColunas da planilha: {list(df_lista.columns)}"

        chassis_list = df_lista['chassi'].dropna().astype(str).tolist()
        _log(f"Total de chassis: {len(chassis_list)}")
        lista_final = []

        for c in chassis_list:
            chassi_limpo = c.strip()
            if chassi_limpo.startswith('~$'):
                continue  # Pula arquivos temporários

            _log(f"Baixando: {chassi_limpo}...")
            url = f"https://jdwarrantysystem.deere.com/api/products/{chassi_limpo}/options?export=EXCEL&language=EN"
            headers = {"Authorization": token}

            try:
                response = requests.get(url, headers=headers, timeout=30)
                _log(f"  Status HTTP: {response.status_code}")
            except Exception as e:
                _log(f"  Erro de conexão no chassi {chassi_limpo}: {e}")
                continue

            if response.status_code == 200:
                try:
                    df_temp = pd.read_excel(io.BytesIO(response.content), engine='openpyxl')
                    df_temp['CHASSI_REFERENCIA'] = chassi_limpo
                    lista_final.append(df_temp)
                    _log(f"  OK — {len(df_temp)} linhas")
                except Exception as e:
                    _log(f"  Erro ao ler Excel do chassi {chassi_limpo}: {e}\n{traceback.format_exc()}")
            else:
                _log(f"  Chassi {chassi_limpo} retornou status {response.status_code}: {response.text[:200]}")

        if lista_final:
            df_consolidado = pd.concat(lista_final, ignore_index=True)

            # Garante que a pasta de destino existe (evita erro se dirname for vazio)
            dest_dir = os.path.dirname(caminho_saida)
            if dest_dir:
                os.makedirs(dest_dir, exist_ok=True)

            df_consolidado.to_excel(caminho_saida, index=False)
            _log(f"Arquivo salvo em: {caminho_saida}")
            return caminho_saida, None

        _log("Nenhum dado extraído.")
        return None, "Nenhum dado foi extraído. Verifique o log em:\n" + LOG_PATH

    except Exception as e:
        tb = traceback.format_exc()
        _log(f"Erro Geral no Processador:\n{tb}")
        return None, f"{e}\n\nLog completo em:\n{LOG_PATH}"