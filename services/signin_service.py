import hashlib
import json
import os
from models.usuarios import Usuario, UsuarioDAO

class SigninService:
    def __init__(self):
        self.dao = UsuarioDAO()

    def registrar_usuario(self, nome, gmail, senha, senha2, dominios_validos):
        erros = []

        try:
            caminho = os.path.join("data", "usuarios.json")

            if os.path.exists(caminho):
                with open(caminho, "r", encoding="utf-8") as f:
                    usuarios = json.load(f)

                for usuario in usuarios:
                    if usuario.get("gmail") == gmail:
                        erros.append("Este email já está cadastrado. Use outro email.")
                        break
        except Exception:
            erros.append("Erro ao acessar o banco de usuários.")

        if any(char.isdigit() for char in nome):
            erros.append("O nome não pode conter números.")

        caracteres_especiais = "!@#$%^&*()-+=_"
        if any(char in caracteres_especiais for char in nome):
            erros.append("O nome não pode conter caracteres especiais.")

        if " " in gmail:
            erros.append("O email não pode conter espaços.")

        email_valido = any(gmail.endswith(dom) for dom in dominios_validos)
        if not email_valido:
            erros.append("Domínio inválido! Use: gmail, hotmail, outlook, yahoo ou live.")

        if senha != senha2:
            erros.append("As senhas não coincidem.")

        if len(senha) < 8:
            erros.append("A senha deve ter no mínimo 8 caracteres.")

        if not any(char.isdigit() for char in senha):
            erros.append("A senha deve conter pelo menos um número.")

        if not any(char in caracteres_especiais for char in senha):
            erros.append("A senha deve conter um caractere especial (ex: @, #, !).")

        if erros:
            return {"erro": " | ".join(erros)}

        self.cadastrar_usuario(nome, gmail, senha)

        return {"sucesso": "Usuário cadastrado com sucesso! aguarde ser redirecionado."}

    def cadastrar_usuario(self, nome, gmail, senha):
        senha_hash = hashlib.sha256(senha.encode()).hexdigest()

        todos = self.dao.listar()

        if not todos:
            novo_id = 1
        else:
            novo_id = max(u["id"] for u in todos) + 1

        usuario = Usuario(
            id=novo_id,
            nome=nome,
            gmail=gmail,
            senha_hash=senha_hash
        )

        self.dao.criar(usuario)
        return usuario
