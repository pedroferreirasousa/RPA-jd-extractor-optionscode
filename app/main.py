import customtkinter as ctk
from scraper import capturar_token_jd
from processor import processar_chassis

class App(ctk.CTk):
    def __init__(self):
        super().__init__()
        self.title("Maqnelson JD Extractor")
        self.geometry("400x300")
        self.token = None

        self.btn_login = ctk.CTkButton(self, text="1. Fazer Login (Pegar Token)", command=self.login)
        self.btn_login.pack(pady=20)

        self.btn_processar = ctk.CTkButton(self, text="2. Processar Lista Excel", command=self.rodar, state="disabled")
        self.btn_processar.pack(pady=20)

    def login(self):
        self.token = capturar_token_jd()
        if self.token:
            self.btn_processar.configure(state="normal")
            ctk.CTkLabel(self, text="Token Ativo ✅", text_color="green").pack()

    def rodar(self):
        caminho = processar_chassis("data/lista_chassis.xlsx", self.token)
        if caminho:
            print(f"Finalizado! Arquivo em: {caminho}")

app = App()
app.mainloop()