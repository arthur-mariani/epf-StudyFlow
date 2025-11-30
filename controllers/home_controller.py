from bottle import request, response, Bottle
from .base_controller import BaseController
from services.sessao_service import SessaoService

class HomeController(BaseController):
    def __init__(self, app):
        super().__init__(app)
        self.sessao_service = SessaoService()
        self.setup_routes()

    def setup_routes(self):
        self.app.route('/home', method='GET', callback=self.exibir_home)
        self.app.route('/logout', method='GET', callback=self.fazer_logout)
        self.app.route('/salvar_sessao', method='POST', callback=self.salvar_sessao_ajax)
        
    def exibir_home(self):
        usuario_logado = request.get_cookie("usuario_logado", secret='chave_secreta_do_projeto')

        if usuario_logado:

            return self.render('home', user=usuario_logado)
        else:
            # Se não tem cookie, redireciona para o login
            return self.redirect('/login')

    def fazer_logout(self):
        # Apaga o cookie e manda o usuário de volta para o login
        response.delete_cookie("usuario_logado")
        return self.redirect('/login')

    def salvar_sessao_ajax(self):
        dados = request.json
        if not dados:
            return {"status": "erro", "msg": "Sem dados"}

        usuario_gmail = request.get_cookie("usuario_logado", secret='chave_secreta_do_projeto')
        
        if not usuario_gmail:
             response.status = 403
             return {"status": "erro", "msg": "Não logado"}

        segundos = dados.get('segundos')
        materia = dados.get('materia')
        
        self.sessao_service.salvar_tempo(usuario_gmail, segundos, materia)

        print(f"Salvando sessão: {usuario_gmail} estudou {segundos}s de {materia}")
        return {"status": "sucesso"}
    
home_routes = Bottle()
home_controller = HomeController(home_routes)