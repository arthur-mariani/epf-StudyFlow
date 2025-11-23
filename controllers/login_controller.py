from bottle import request, Bottle
from .base_controller import BaseController
from services.login_service import LoginService


class LoginController(BaseController):
    def __init__(self, app):
        super().__init__(app)
        self.login_service = LoginService()
        self.setup_routes()

    def setup_routes(self):
        self.app.route('/login', method='GET', callback=self.realizar_login)
        self.app.route('/login', method='POST', callback=self.autenticar_usuario)

    def realizar_login(self, error_message=None, success_message=None):
        return self.render(
            'login',
            action="/login",
            error=error_message,
            success=success_message,
            request=request
        )

    def autenticar_usuario(self):
        email_input = request.forms.get("gmail")
        senha_input = request.forms.get("senha")

        login_ok = self.login_service.validar_login(email_input, senha_input)

        if login_ok:
            return self.realizar_login(success_message="Login realizado com sucesso! Redirecionando...")
        else:
            return self.realizar_login(error_message="Email ou senha incorretos.")


login_routes = Bottle()
login_controller = LoginController(login_routes)
