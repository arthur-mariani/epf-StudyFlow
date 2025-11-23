import hashlib
import json
import os


class LoginService:
    def __init__(self):
        self.caminho_arquivo = os.path.join('data', 'usuarios.json')

    def validar_login(self, email_input, senha_input):

        senha_hash_input = hashlib.sha256(senha_input.encode()).hexdigest()

        usuarios = self._carregar_usuarios()

        for usuario in usuarios:
            if (
                usuario.get("gmail") == email_input and
                usuario.get("senha_hash") == senha_hash_input
            ):
                return True

        return False

    def _carregar_usuarios(self):
        if not os.path.exists(self.caminho_arquivo):
            print(f"Arquivo não encontrado em: {self.caminho_arquivo}")
            return []

        try:
            with open(self.caminho_arquivo, "r", encoding="utf-8") as f:
                return json.load(f)
        except json.JSONDecodeError:
            print("Erro ao ler o JSON (formato inválido).")
            return []
