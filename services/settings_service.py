import hashlib
from models.usuarios import UsuarioDAO, Usuario

class SettingsService:
    def __init__(self):
        self.dao = UsuarioDAO()
        self.DOMINIOS_VALIDOS = [
            "@gmail.com",
            "@hotmail.com",
            "@outlook.com",
            "@yahoo.com",
            "@live.com"
        ]

    def atualizar_email(self, email_atual, novo_email, senha_digitada):

        if " " in novo_email:
            return False, "O novo email não pode conter espaços."

        email_valido = any(novo_email.endswith(dom) for dom in self.DOMINIOS_VALIDOS)
        if not email_valido:
            return False, "Domínio inválido! Use: gmail, hotmail, outlook, yahoo ou live."

        usuarios = self.dao.listar()
        if next((u for u in usuarios if u['gmail'] == novo_email), None):
            return False, "Email já existe!"

        usuario_banco = next((u for u in usuarios if u['gmail'] == email_atual), None)
        senha_hash = hashlib.sha256(senha_digitada.encode()).hexdigest()

        if usuario_banco and usuario_banco['senha_hash'] == senha_hash:
            novo_user = Usuario(
                id=usuario_banco['id'],
                nome=usuario_banco['nome'],
                gmail=novo_email,
                senha_hash=usuario_banco['senha_hash']
            )
            self.dao.atualizar(usuario_banco['id'], novo_user)
            return True, "Email atualizado com sucesso!"
        
        return False, "Senha incorreta!"

    def atualizar_senha(self, email_atual, senha_atual, nova_senha):

        erros = []
        if len(nova_senha) < 8: erros.append("Mínimo 8 caracteres.")
        if not any(char.isdigit() for char in nova_senha): erros.append("Falta número.")
        caracteres = "!@#$%^&*()-+=_"
        if not any(char in caracteres for char in nova_senha): erros.append("Falta caractere especial.")

        if erros: return False, " | ".join(erros)

        senha_atual_hash = hashlib.sha256(senha_atual.encode()).hexdigest()
        usuarios = self.dao.listar()
        usuario_banco = next((u for u in usuarios if u['gmail'] == email_atual), None)

        if usuario_banco and usuario_banco['senha_hash'] == senha_atual_hash:
            nova_senha_hash = hashlib.sha256(nova_senha.encode()).hexdigest()
            novo_user = Usuario(
                id=usuario_banco['id'],
                nome=usuario_banco['nome'],
                gmail=usuario_banco['gmail'],
                senha_hash=nova_senha_hash
            )
            self.dao.atualizar(usuario_banco['id'], novo_user)
            return True, "Senha alterada com sucesso!"
        
        return False, "Senha atual incorreta!"

    def deletar_conta(self, email_atual):
        usuarios = self.dao.listar()
        usuario_banco = next((u for u in usuarios if u['gmail'] == email_atual), None)
        if usuario_banco:
            self.dao.deletar(usuario_banco['id'])
            return True
        return False