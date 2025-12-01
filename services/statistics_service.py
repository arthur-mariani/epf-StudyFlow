import json
from datetime import datetime, timedelta
from collections import defaultdict
import os

class StatisticsService:
    def __init__(self):
        base_dir = os.path.dirname(os.path.abspath(__file__))
        self.sessoes_path = os.path.join(base_dir, "..", "data", "sessoes.json")

    def carregar_sessoes(self):
        try:
            with open(self.sessoes_path, "r", encoding="utf-8") as f:
                return json.load(f)
        except FileNotFoundError:
            return []
        except json.JSONDecodeError:
            return []

    def filtrar_por_usuario(self, gmail):
        sessoes = self.carregar_sessoes()
        return [s for s in sessoes if s.get("usuario_gmail") == gmail]

    def segundos_para_horas(self, segundos):
        return round(segundos / 3600, 2)

    def estatisticas_por_periodo(self, gmail):
        sessoes = self.filtrar_por_usuario(gmail)

        horas_por_dia = defaultdict(float)
        datas_existentes = []

        for s in sessoes:
            try:
                segundos = int(s.get("segundos", 0))
                data = datetime.strptime(s["data_hora"], "%Y-%m-%d %H:%M:%S")
            except (ValueError, KeyError):
                continue

            horas = self.segundos_para_horas(segundos)
            dia_key = data.strftime("%Y-%m-%d")
            horas_por_dia[dia_key] += horas
            datas_existentes.append(data.date())

        if datas_existentes:
            data_final = max(datas_existentes)
        else:
            data_final = datetime.now().date()

        dias_completos = []
        for i in range(15):
            dia = data_final - timedelta(days=i)
            dia_str = dia.strftime("%Y-%m-%d")
            horas = horas_por_dia.get(dia_str, 0)
            dias_completos.append((dia_str, horas))

        dias_completos.reverse()

        ultimos_7 = dias_completos[-7:]
        semana_passada = dias_completos[-15:-7]

        horas_por_mes = defaultdict(float)
        for s in sessoes:
            try:
                segundos = int(s.get("segundos", 0))
                data = datetime.strptime(s["data_hora"], "%Y-%m-%d %H:%M:%S")
            except (ValueError, KeyError):
                continue

            horas = self.segundos_para_horas(segundos)
            ano_mes = data.strftime("%Y-%m")
            horas_por_mes[ano_mes] += horas

        return {
            "por_dia": {
                "labels": [d[0] for d in ultimos_7],
                "valores": [d[1] for d in ultimos_7]
            },
            "semana": {
                "labels": [d[0] for d in semana_passada],
                "valores": [d[1] for d in semana_passada]
            },
            "meses": {
                "labels": list(horas_por_mes.keys()),
                "valores": list(horas_por_mes.values())
            }
        }