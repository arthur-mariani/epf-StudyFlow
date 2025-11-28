from bottle import request, response, Bottle
from .base_controller import BaseController

class HomeController(BaseController):
    def __init__(self, app):
        super().__init__(app)
        self.setup_routes()

    def setup_routes(self):
        # Rota principal após o login
        self.app.route('/home', method='GET', callback=self.exibir_home)
        
        # Rota de sair
        self.app.route('/logout', method='GET', callback=self.fazer_logout)

    def exibir_home(self):
        # 1. VERIFICAÇÃO DE SEGURANÇA
        # Tenta recuperar o cookie criado no LoginController
        # ATENÇÃO: O 'secret' deve ser IGUAL ao usado no login_controller.py
        usuario_logado = request.get_cookie("usuario_logado", secret='chave_secreta_do_projeto')

        if usuario_logado:
            # 2. Se tem cookie, mostra a tela Home
            # Passamos o 'user' para o template poder escrever "Olá, Fulano"
            return self.render('home', user=usuario_logado)
        else:
            # 3. Se não tem cookie, redireciona para o login
            return self.redirect('/login')

    def fazer_logout(self):
        # Apaga o cookie e manda o usuário de volta para o login
        response.delete_cookie("usuario_logado")
        return self.redirect('/login')

# Criação da instância para exportar (se você usar esse padrão de exportação)
home_routes = Bottle()
home_controller = HomeController(home_routes)