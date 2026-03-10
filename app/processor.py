import pandas as pd
import requests
import io

def processar_chassis(lista_path, token):
    try:
        # Lê a planilha mestre
        df_lista = pd.read_excel(lista_path, engine='openpyxl')
        
        # Padroniza nomes de colunas para evitar erros de digitação
        df_lista.columns = [str(c).lower().strip() for c in df_lista.columns]
        
        if 'chassi' not in df_lista.columns:
            print(f"❌ Coluna 'chassi' não encontrada. Colunas: {list(df_lista.columns)}")
            return None

        chassis_list = df_lista['chassi'].dropna().astype(str).tolist()
        lista_final = []

        for c in chassis_list:
            chassi_limpo = c.strip()
            # Pula arquivos temporários se o loop pegar lixo
            if chassi_limpo.startswith('~$'): continue
            
            print(f"📥 Baixando dados do chassi: {chassi_limpo}...")
            url = f"https://jdwarrantysystem.deere.com/api/products/{chassi_limpo}/options?export=EXCEL&language=EN"
            headers = {"Authorization": token}
            
            response = requests.get(url, headers=headers)
            
            if response.status_code == 200:
                try:
                    # Lemos o conteúdo binário direto (response.content)
                    df_temp = pd.read_excel(io.BytesIO(response.content), engine='openpyxl')
                    df_temp['CHASSI_REFERENCIA'] = chassi_limpo
                    lista_final.append(df_temp)
                    print(f"✅ Dados de {chassi_limpo} processados.")
                except Exception as e:
                    print(f"⚠️ Erro ao processar o Excel da API para {chassi_limpo}: {e}")
            else:
                print(f"❌ Erro na API ({response.status_code}) para o chassi {chassi_limpo}")

        if lista_final:
            df_consolidado = pd.concat(lista_final, ignore_index=True)
            saida = "data/resultados/Relatorio_Geral_JD.xlsx"
            df_consolidado.to_excel(saida, index=False)
            print(f"\n🏁 SUCESSO! Relatório final salvo em: {saida}")
            return saida
        
        return None

    except Exception as e:
        print(f"💥 Erro crítico no processador: {e}")
        return None