import hashlib
import os
import json

DATA_DIR = os.path.join(os.path.dirname(__file__), '..', 'data')
DATA_PATH = os.path.join(DATA_DIR, "usuarios.json")

class Usuario:
    def __init__(self, id, nome, gmail, senha_hash):
        self.id = id
        self.nome = nome
        self.gmail = gmail
        self.senha_hash = senha_hash


class UsuarioDAO:
    def __init__(self):
        if not os.path.exists(DATA_PATH):
            with open(DATA_PATH, "w") as f:
                json.dump([], f)

    def _ler(self):
        with open(DATA_PATH, "r") as f:
            return json.load(f)

    def _salvar(self, lista):
        with open(DATA_PATH, "w") as f:
            json.dump(lista, f, indent=4)

    def criar(self, usuario: Usuario):
        usuarios = self._ler()
        usuarios.append(usuario.__dict__)
        self._salvar(usuarios)

    def listar(self):
        return self._ler()

    def buscar_por_id(self, id):
        usuarios = self._ler()
        for u in usuarios:
            if u["id"] == id:
                return u
        return None

    def atualizar(self, id, usuario_atualizado: Usuario):
        usuarios = self._ler()
        for i, u in enumerate(usuarios):
            if u["id"] == id:
                usuarios[i] = usuario_atualizado.__dict__
                self._salvar(usuarios)
                return True
        return False

    def deletar(self, id):
        usuarios = self._ler()
        usuarios = [u for u in usuarios if u["id"] != id]
        self._salvar(usuarios)
