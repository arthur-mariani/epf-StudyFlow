from bottle import Bottle, request
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
        self.setup_routes()


    def setup_routes(self):
        self.app.route('/signin', method='GET', callback=self.resultado)
        self.app.route('/signin', method='POST', callback=self.registrar_usuario)


    def resultado(self, error_message=None):
        return self.render('signin', action="/signin", error=error_message)


    def registrar_usuario(self):
        nome = request.forms.get("nome")
        gmail = request.forms.get("gmail")
        senha = request.forms.get("senha")
        senha2 = request.forms.get("senha2")

        erros = []

        if " " in gmail:
            erros.append("O email não pode conter espaços.")

        email_valido = any(gmail.endswith(dom) for dom in DOMINIOS_VALIDOS)
        if not email_valido:
             erros.append("Domínio inválido! Use: gmail, hotmail, outlook, yahoo ou live.")

        if senha != senha2:
            erros.append("As senhas não coincidem.")

        if len(erros) > 0:

            mensagem_final = " | ".join(erros)
            return self.resultado(f"Erro: {mensagem_final}")

        self.signin_service.cadastrar_usuario(nome, gmail, senha)
        return self.resultado("Usuário cadastrado com sucesso!")

signin_routes = Bottle()
signin_controller = SigninController(signin_routes)
