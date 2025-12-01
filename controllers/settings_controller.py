from bottle import Bottle, request, response
from .base_controller import BaseController
from services.settings_service import SettingsService

class SettingsController(BaseController):
    def __init__(self, app):
        super().__init__(app)
        self.settings_service = SettingsService()
        self.setup_routes()

    def setup_routes(self):
     
        self.app.route('/configuracoes', method='GET', callback=self.view_settings)
        self.app.route('/configuracoes/email', method='POST', callback=self.update_email)
        self.app.route('/configuracoes/senha', method='POST', callback=self.update_password)
        self.app.route('/configuracoes/delete', method='POST', callback=self.delete_account)

    def view_settings(self):
        usuario_gmail = request.get_cookie("usuario_logado", secret='chave_secreta_do_projeto')
        if not usuario_gmail:
            return self.redirect('/login')
 
        return self.render('settings')

    def update_email(self):
        usuario_gmail = request.get_cookie("usuario_logado", secret='chave_secreta_do_projeto')
        if not usuario_gmail: return self.redirect('/login')

        novo_gmail = request.forms.get('novo_gmail')
        senha_atual = request.forms.get('senha_atual')

        sucesso, mensagem = self.settings_service.atualizar_email(usuario_gmail, novo_gmail, senha_atual)

        if sucesso:
            response.set_cookie("usuario_logado", novo_gmail, secret='chave_secreta_do_projeto', path='/')
            return self.render('settings', msg=mensagem)
        else:
            return self.render('settings', erro=mensagem)

    def update_password(self):
        usuario_gmail = request.get_cookie("usuario_logado", secret='chave_secreta_do_projeto')
        if not usuario_gmail: return self.redirect('/login')

        senha_atual = request.forms.get('senha_atual')
        nova_senha = request.forms.get('nova_senha')

        sucesso, mensagem = self.settings_service.atualizar_senha(usuario_gmail, senha_atual, nova_senha)

        if sucesso:
            return self.render('settings', msg=mensagem)
        else:
            return self.render('settings', erro=mensagem)

    def delete_account(self):
        usuario_gmail = request.get_cookie("usuario_logado", secret='chave_secreta_do_projeto')
        if not usuario_gmail: return self.redirect('/login')

        sucesso = self.settings_service.deletar_conta(usuario_gmail)

        if sucesso:
            response.delete_cookie("usuario_logado", path='/')
            return self.redirect('/login')
        
        return self.redirect('/configuracoes')


settings_routes = Bottle()
settings_controller = SettingsController(settings_routes)