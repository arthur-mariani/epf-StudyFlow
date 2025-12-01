from bottle import request, Bottle, response
from .base_controller import BaseController
from services.statistics_service import StatisticsService

class StatisticsController(BaseController):
    def __init__(self, app):
        super().__init__(app)
        self.statistics_service = StatisticsService()
        self.setup_routes()

    def setup_routes(self):
        self.app.route('/estatisticas', method='GET', callback=self.exibir_pagina)
        self.app.route('/estatisticas/dados', method='GET', callback=self.obter_dados)

    def exibir_pagina(self, error_message=None, success_message=None):
        usuario = request.get_cookie("usuario_logado", secret='chave_secreta_do_projeto')

        if not usuario:
            return self.redirect('/login')

        dados = self.statistics_service.estatisticas_por_periodo(usuario)

        horas_semana_passada = dados.get("horas_semana_passada", 0)

        return self.render(
            'estatisticas',
            error=error_message,
            success=success_message,
            request=request,
            horas_semana_passada=horas_semana_passada
        )

    def obter_dados(self):
        usuario = request.get_cookie("usuario_logado", secret='chave_secreta_do_projeto')

        if not usuario:
            response.status = 401
            return {"erro": "Usuário não autenticado"}

        dados = self.statistics_service.estatisticas_por_periodo(usuario)

        response.content_type = "application/json"
        return dados

statistics_routes = Bottle()
statistics_controller = StatisticsController(statistics_routes)
