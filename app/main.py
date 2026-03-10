import customtkinter as ctk
from tkinter import filedialog, messagebox
import os
import sys
import threading

# Força o Python a olhar para a pasta onde o .exe foi descompactado
if getattr(sys, 'frozen', False):
    # Se estiver rodando como .exe
    bundle_dir = sys._MEIPASS
else:
    # Se estiver rodando como script .py
    bundle_dir = os.path.dirname(os.path.abspath(__file__))

if bundle_dir not in sys.path:
    sys.path.insert(0, bundle_dir)

# Agora os imports devem funcionar
try:
    from scraper import capturar_token
    from processor import processar_chassis
except ImportError as e:
    # Se ainda der erro, isso vai nos mostrar exatamente onde ele tentou buscar
    messagebox.showerror("Erro de Importação", f"Não encontrou os módulos: {e}\nPath: {sys.path}")

class App(ctk.CTk):
    def __init__(self):
        super().__init__()
        self.title("JD Extractor - Maqnelson")
        self.geometry("400x350")
        self.token = None
        self.caminho_planilha = None

        self.label = ctk.CTkLabel(self, text="Extrator de Dados John Deere", font=("Arial", 18, "bold"))
        self.label.pack(pady=20)

        self.btn_login = ctk.CTkButton(self, text="1. Fazer Login (Okta)", command=self.fazer_login)
        self.btn_login.pack(pady=10)

        self.btn_upload = ctk.CTkButton(self, text="2. Selecionar Planilha (.xlsx)", command=self.selecionar_arquivo, state="disabled")
        self.btn_upload.pack(pady=10)

        self.btn_processar = ctk.CTkButton(self, text="3. Iniciar Extração", command=self.rodar, state="disabled", fg_color="green")
        self.btn_processar.pack(pady=10)

    def fazer_login(self):
        try:
            self.token = capturar_token()
            if self.token:
                messagebox.showinfo("Sucesso", "Login efetuado e Token capturado!")
                self.btn_upload.configure(state="normal")
            else:
                messagebox.showerror("Erro", "Não foi possível capturar o token.")
        except Exception as e:
            messagebox.showerror("Erro no Login", str(e))

    def selecionar_arquivo(self):
        file_path = filedialog.askopenfilename(filetypes=[("Excel files", "*.xlsx")])
        if file_path:
            self.caminho_planilha = file_path
            self.btn_processar.configure(state="normal")
            messagebox.showinfo("Arquivo Selecionado", f"Planilha carregada:\n{os.path.basename(file_path)}")

    def rodar(self):
        if not self.token or not self.caminho_planilha:
            return

        # Pergunta onde salvar antes de processar
        caminho_saida = filedialog.asksaveasfilename(
            title="Salvar relatório como...",
            defaultextension=".xlsx",
            filetypes=[("Excel files", "*.xlsx")],
            initialfile="Relatorio_Extraido_JD.xlsx",
        )
        if not caminho_saida:
            return  # Usuário cancelou

        self.btn_processar.configure(state="disabled", text="Processando...")

        def _processar():
            resultado, erro = processar_chassis(self.caminho_planilha, self.token, caminho_saida)
            # Volta para a thread da UI
            self.after(0, lambda: self._finalizar(resultado, erro))

        threading.Thread(target=_processar, daemon=True).start()

    def _finalizar(self, resultado, erro):
        if resultado:
            messagebox.showinfo("Fim", f"Processo concluído!\nSalvo em: {resultado}")
        else:
            messagebox.showerror("Erro no Processamento", erro or "Erro desconhecido.")
        self.btn_processar.configure(state="normal", text="3. Iniciar Extração")
        self.btn_processar.configure(state="normal", text="3. Iniciar Extração")

if __name__ == "__main__":
    app = App()
    app.mainloop()