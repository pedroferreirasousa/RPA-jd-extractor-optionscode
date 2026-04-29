# JD Extractor

RPA desktop desenvolvido para a **Maqnelson** que automatiza a extração de **option codes** de chassis John Deere diretamente do [JD Warranty System](https://jdwarrantysystem.deere.com/) e persiste os dados em banco de dados MySQL.

---

## Tecnologias

| Tecnologia | Uso |
|---|---|
| [Python 3.10+](https://www.python.org/downloads/) | Linguagem base |
| [CustomTkinter](https://github.com/TomSchimansky/CustomTkinter) | Interface gráfica desktop |
| [Selenium Wire](https://github.com/wkeeling/selenium-wire) | Automação do Chrome + interceptação de requisições para captura do token |
| [WebDriver Manager](https://github.com/SergeyPirogov/webdriver_manager) | Gerenciamento automático do ChromeDriver |
| [Requests](https://docs.python-requests.org/) | Chamadas à API do JD Warranty System |
| [Pandas](https://pandas.pydata.org/) + [OpenPyXL](https://openpyxl.readthedocs.io/) | Leitura da planilha de chassis e geração do relatório `.xlsx` |
| [mysql-connector-python](https://dev.mysql.com/doc/connector-python/en/) | Inserção dos dados no MySQL |
| [python-dotenv](https://github.com/theskumar/python-dotenv) | Gerenciamento de variáveis de ambiente |
| [PyInstaller](https://pyinstaller.org/) | Build do executável `.exe` |
| [Google Chrome](https://www.google.com/chrome/) | Navegador utilizado pelo Selenium |

---

## Como funciona

```
Planilha .xlsx (lista de chassis)
        ↓
  Login no portal JD (Okta)   →   Token Bearer capturado via Selenium Wire
        ↓
  Requisição à API JD por chassis   →   Dados de options (code, description, datas…)
        ↓
  Consolidação em relatório .xlsx   +   Inserção no MySQL (tb_EquipmentOptions)
```

O Selenium abre o Chrome, o usuário faz login normalmente pelo Okta e realiza uma busca no portal. O Selenium Wire intercepta as requisições HTTP em segundo plano e extrai o token Bearer das chamadas à API. Com o token em mãos, a aplicação consulta cada chassi da planilha diretamente via API, sem necessidade de interação com o navegador novamente.

---

## Instalação (para desenvolvimento ou build)

> **Usuários do `.exe`:** pule esta seção. Basta ter o [Google Chrome](https://www.google.com/chrome/) instalado e configurar o `.env`.

```bash
# Clone o repositório
git clone <url-do-repo>
cd jd-extractor

# Crie e ative o ambiente virtual
# O venv isola as dependências do projeto e é necessário para o build do .exe
python -m venv .venv
.venv\Scripts\activate      # Windows

# Instale as dependências
pip install -r app/requirements.txt
```

---

## Configuração

Crie um arquivo `.env` na raiz do projeto (ou na mesma pasta do `.exe`) com as credenciais do banco:

```env
DB_HOST=seu_host
DB_PORT=3306
DB_USER=usuario
DB_PASSWORD=senha
DB_NAME=db_Cor_Maqnelson_RPA
```

> O arquivo `.env` está no `.gitignore` e **nunca deve ser versionado**.

---

## Como usar

### Executando via `.exe`

1. Coloque o arquivo `.env` na mesma pasta do `main.exe`
2. Execute `main.exe`

### Executando via Python (desenvolvimento)

```bash
cd app
python main.py
```

---

## Passo a passo na interface

**1. Fazer Login (Okta)**
- Clique em **"1. Fazer Login (Okta)"**
- O Chrome abrirá automaticamente com o portal JD
- Faça o login com suas credenciais e aprove no Okta
- Realize uma busca por qualquer chassi no portal — isso aciona a API e permite a captura do token
- Ao ver a mensagem de sucesso, o token foi capturado e o Chrome fechará

**2. Selecionar Planilha (.xlsx)**
- Clique em **"2. Selecionar Planilha (.xlsx)"**
- Selecione a planilha com a lista de chassis a serem consultados
- A planilha deve conter uma coluna chamada exatamente `chassi`

**3. Iniciar Extração**
- Clique em **"3. Iniciar Extração"**
- Escolha onde salvar o relatório consolidado `.xlsx`
- O processo inicia: cada chassi da planilha é consultado na API, os dados de option codes são coletados, salvos no banco MySQL e incluídos no relatório final

> Um arquivo de log é gerado automaticamente no Desktop: `jd_extractor_log.txt`  
> Em caso de erros, consulte esse arquivo para diagnóstico.

---

## Estrutura do projeto

```
jd-extractor/
├── app/
│   ├── main.py          # Interface gráfica (CustomTkinter)
│   ├── scraper.py       # Captura do token via Selenium Wire
│   ├── processor.py     # Lógica de extração e processamento
│   ├── db_inserter.py   # Inserção dos dados no MySQL
│   └── requirements.txt
├── data/
│   └── resultados/      # Pasta sugerida para salvar relatórios gerados
├── DOCS/                # Documentação e arquivos de referência
├── .env                 # (não versionado) Credenciais do banco
├── .gitignore
├── main.spec            # Configuração do build PyInstaller
└── README.md
```

---

## Banco de dados

Os dados são inseridos na tabela `tb_EquipmentOptions` com a chave única `(pin, code)`.  
Caso o par já exista, a inserção atualiza apenas `description`, `deleted_at`, `deleted_by` e `updated_at` (sem duplicar o registro).

| Campo | Descrição |
|---|---|
| `pin` | Número do chassi (PIN) |
| `code` | Código da option |
| `description` | Descrição da option |
| `created_at` | Data de criação registrada no portal JD |
| `created_at_db` | Data/hora da inserção no banco |
| `updated_at` | Data/hora da última atualização |

---

## Build do executável

```bash
pyinstaller main.spec
```

O executável é gerado em `build/`. Antes de distribuir, inclua o arquivo `.env` na mesma pasta do `.exe`.

---

## Build do executável

```bash
pyinstaller main.spec
```

O executável é gerado em `build/`. Inclua o `.env` na mesma pasta antes de distribuir.
