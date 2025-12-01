from models.sessao import SessaoDAO, Sessao
from models.usuarios import UsuarioDAO

class SessaoService:
    def __init__(self):
        self.sessao_dao = SessaoDAO()
        self.usuario_dao = UsuarioDAO()
        
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
    
    def obter_ranking_geral(self):
        todas_sessoes = self.sessao_dao.listar_todos()
        ranking_dict = {}

        for sessao in todas_sessoes:
            email = sessao['usuario_gmail']
            tempo = sessao['segundos']

            if email in ranking_dict:
                ranking_dict[email] += tempo
            else:
                ranking_dict[email] = tempo

        ranking_ordenado = sorted(ranking_dict.items(), key=lambda item: item[1], reverse=True)

        todos_usuarios = self.usuario_dao.listar()
        mapa_usuarios = {u['gmail']: u for u in todos_usuarios}

        resultado_final = []
        for i, (email, total_segundos) in enumerate(ranking_ordenado):
            
            dados_usuario = mapa_usuarios.get(email)
            
            if dados_usuario:
                nome_exibicao = f"{dados_usuario['nome']} - {dados_usuario['id']}"
            else:
                nome_exibicao = email

            horas = int(total_segundos // 3600)
            minutos = int((total_segundos % 3600) // 60)
            tempo_fmt = f"{horas}h {minutos}m"

            resultado_final.append({
                "posicao": i + 1,
                "nome": nome_exibicao,
                "tempo": tempo_fmt
            })

        return resultado_final