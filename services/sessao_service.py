from models.sessao import SessaoDAO, Sessao

class SessaoService:
    def __init__(self):
        self.sessao_dao = SessaoDAO()

    def salvar_tempo(self, usuario_gmail, segundos, modo):

        todas = self.sessao_dao.listar_todos()
        if todas:

            novo_id = max(item['id'] for item in todas) + 1
        else:
            novo_id = 1

        nova_sessao = Sessao(
            id=novo_id,
            usuario_gmail=usuario_gmail,
            segundos=int(segundos),
            modo=modo
        )

        self.sessao_dao.criar(nova_sessao)
        return True