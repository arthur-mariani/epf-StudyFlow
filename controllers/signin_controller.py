from bottle import request, Bottle
from .base_controller import BaseController
from services.signin_service import SigninService


DOMINIOS_VALIDOS = [
    "@gmail.com",
    "@hotmail.com",
    "@outlook.com",
    "@yahoo.com",
    "@live.com"
]


class SigninController(BaseController):
    def __init__(self, app):
        super().__init__(app)

        self.signin_service = SigninService()
        self.dominios_validos = DOMINIOS_VALIDOS
        self.setup_routes()


    def setup_routes(self):
        self.app.route('/signin', method='GET', callback=self.resultado)
        self.app.route('/signin', method='POST', callback=self.registrar_usuario)


    def resultado(self, error_message=None, success_message=None):
        return self.render(
            'signin',
            action="/signin",
            error=error_message,
            success=success_message,
            request=request
        )


    def registrar_usuario(self):
        nome = request.forms.get("nome")
        gmail = request.forms.get("gmail")
        senha = request.forms.get("senha")
        senha2 = request.forms.get("senha2")

        resultado = self.signin_service.registrar_usuario(
            nome=nome,
            gmail=gmail,
            senha=senha,
            senha2=senha2,
            dominios_validos=self.dominios_validos
        )

        if resultado.get("erro"):
            return self.resultado(error_message=resultado["erro"])

        return self.resultado(success_message=resultado["sucesso"])


signin_routes = Bottle()
signin_controller = SigninController(signin_routes)