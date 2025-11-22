import json
import os
from datetime import datetime

# Caminho para a pasta de dados
DATA_DIR = os.path.join(os.path.dirname(__file__), '..', 'data')

class Materia:
    def __init__(self, id, user_id, nome, cor="#007bff"):
        self.id = id
        self.user_id = user_id
        self.nome = nome
        self.cor = cor # Ex: cor em hexadecimal para o front-end

    def to_dict(self):
        return {
            'id': self.id,
            'user_id': self.user_id,
            'nome': self.nome,
            'cor': self.cor
        }

    @classmethod
    def from_dict(cls, data):
        return cls(**data)

# Classe Pai (Abstração)
class SessaoEstudo:
    def __init__(self, id, materia_id, duracao_minutos, data_registro=None):
        self.id = id
        self.materia_id = materia_id
        self.duracao_minutos = duracao_minutos
        self.data_registro = data_registro or datetime.now().strftime("%Y-%m-%d %H:%M")
        self.tipo = "Normal" # Identificador do tipo

    def calcular_pontos(self):
        return self.duracao_minutos * 10  # 10 pontos por minuto

    def to_dict(self):
        return {
            'id': self.id,
            'materia_id': self.materia_id,
            'duracao_minutos': self.duracao_minutos,
            'data_registro': self.data_registro,
            'tipo': self.tipo
        }

    @classmethod
    def from_dict(cls, data):
        tipo = data.get('tipo')
        if tipo == 'Pomodoro':
            return SessaoPomodoro(**data)
        return cls(**data)

class SessaoPomodoro(SessaoEstudo):
    def __init__(self, id, materia_id, duracao_minutos, data_registro=None, **kwargs):
        super().__init__(id, materia_id, duracao_minutos, data_registro)
        self.tipo = "Pomodoro"

    def calcular_pontos(self):
        return self.duracao_minutos * 20  # Pomodoro vale o dobro!

# --- GERENCIADOR DE DADOS (Persistence) ---
class StudyModel:
    FILE_MATERIAS = os.path.join(DATA_DIR, 'materias.json')
    FILE_SESSOES = os.path.join(DATA_DIR, 'sessoes.json')

    def __init__(self):
        self.materias = self._load_json(self.FILE_MATERIAS, Materia)
        self.sessoes = self._load_json(self.FILE_SESSOES, SessaoEstudo)

    def _load_json(self, path, model_cls):
        if not os.path.exists(path):
            return []
        with open(path, 'r', encoding='utf-8') as f:
            data = json.load(f)
            return [model_cls.from_dict(item) for item in data]

    def _save_json(self, path, lista_objetos):
        with open(path, 'w', encoding='utf-8') as f:
            json.dump([obj.to_dict() for obj in lista_objetos], f, indent=4, ensure_ascii=False)

    # --- MÉTODOS DE MATÉRIAS ---
    def add_materia(self, materia):
        self.materias.append(materia)
        self._save_json(self.FILE_MATERIAS, self.materias)

    def get_materias_by_user(self, user_id):
        return [m for m in self.materias if m.user_id == user_id]
    
    def get_materia_by_id(self, id):
        return next((m for m in self.materias if m.id == id), None)

    # --- MÉTODOS DE SESSÕES ---
    def add_sessao(self, sessao):
        self.sessoes.append(sessao)
        self._save_json(self.FILE_SESSOES, self.sessoes)

    def get_sessoes_by_user(self, user_id):
        # Filtra as sessões cujas matérias pertencem ao usuário
        user_materias_ids = [m.id for m in self.get_materias_by_user(user_id)]
        return [s for s in self.sessoes if s.materia_id in user_materias_ids]