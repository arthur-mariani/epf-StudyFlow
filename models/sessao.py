import os
import json
from datetime import datetime

DATA_DIR = os.path.join(os.path.dirname(__file__), '..', 'data')
DATA_PATH = os.path.join(DATA_DIR, "sessoes.json")

class Sessao:
    def __init__(self, id, usuario_gmail, segundos, materia, data_hora=None):
        self.id = id
        self.usuario_gmail = usuario_gmail
        self.segundos = segundos
        self.materia = materia
        self.data_hora = data_hora or datetime.now().strftime("%Y-%m-%d %H:%M:%S")

class SessaoDAO:
    def __init__(self):
        
        if not os.path.exists(DATA_DIR):
            os.makedirs(DATA_DIR)
            
        if not os.path.exists(DATA_PATH):
            with open(DATA_PATH, "w") as f:
                json.dump([], f)

    def _ler(self):
        with open(DATA_PATH, "r") as f:
            return json.load(f)

    def _salvar(self, lista):
        with open(DATA_PATH, "w") as f:
            json.dump(lista, f, indent=4)

    def criar(self, sessao: Sessao):
        lista_sessoes = self._ler()
        lista_sessoes.append(sessao.__dict__)
        self._salvar(lista_sessoes)

    def listar_todos(self):
        return self._ler()

    def listar_por_usuario(self, gmail):
        todos = self._ler()
        return [s for s in todos if s['usuario_gmail'] == gmail]