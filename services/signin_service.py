import hashlib
from models.usuarios import Usuario, UsuarioDAO

class SigninService:
    def __init__(self):
        self.dao = UsuarioDAO()

    def cadastrar_usuario(self, nome, gmail, senha):
        senha_hash = hashlib.sha256(senha.encode()).hexdigest()

        todos = self.dao.listar()
        novo_id = len(todos) + 1

        usuario = Usuario(
            id=novo_id,
            nome=nome,
            gmail=gmail,
            senha_hash=senha_hash
        )

        self.dao.criar(usuario)
        return usuario
