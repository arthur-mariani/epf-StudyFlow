import hashlib
from bottle import Bottle, get, post, request, response, redirect, template
from models.usuarios import UsuarioDAO, Usuario

settings_app = Bottle()

DOMINIOS_VALIDOS = [
    "@gmail.com",
    "@hotmail.com",
    "@outlook.com",
    "@yahoo.com",
    "@live.com"
]

@settings_app.get('/configuracoes')
def view_settings():
    usuario_gmail = request.get_cookie("usuario_logado", secret='chave_secreta_do_projeto')
    if not usuario_gmail:
        return redirect('/login')
    return template('settings')

@settings_app.post('/configuracoes/email')
def update_email():
    usuario_gmail = request.get_cookie("usuario_logado", secret='chave_secreta_do_projeto')
    if not usuario_gmail: return redirect('/login')

    novo_gmail = request.forms.get('novo_gmail')
    senha_atual = request.forms.get('senha_atual')

    if " " in novo_gmail:
        return template('settings', erro="O novo email não pode conter espaços.")

    email_valido = any(novo_gmail.endswith(dom) for dom in DOMINIOS_VALIDOS)
    if not email_valido:
        return template('settings', erro="Domínio inválido! Use: gmail, hotmail, outlook, yahoo ou live.")

    senha_atual_hash = hashlib.sha256(senha_atual.encode()).hexdigest()

    dao = UsuarioDAO()
    usuarios = dao.listar()
    usuario_atual = next((u for u in usuarios if u['gmail'] == usuario_gmail), None)

    if usuario_atual and usuario_atual['senha_hash'] == senha_atual_hash:
        novo_user = Usuario(
            id=usuario_atual['id'],
            nome=usuario_atual['nome'],
            gmail=novo_gmail,
            senha_hash=usuario_atual['senha_hash']
        )
        dao.atualizar(usuario_atual['id'], novo_user)
        
        response.set_cookie("usuario_logado", novo_gmail, secret='chave_secreta_do_projeto', path='/')
        
        print(f"DEBUG: Email alterado de {usuario_gmail} para {novo_gmail}")
        return template('settings', msg="Email atualizado com sucesso!")
    else:
        return template('settings', erro="Senha incorreta!")

@settings_app.post('/configuracoes/senha')
def update_password():
    usuario_gmail = request.get_cookie("usuario_logado", secret='chave_secreta_do_projeto')
    if not usuario_gmail: return redirect('/login')

    senha_atual = request.forms.get('senha_atual')
    nova_senha = request.forms.get('nova_senha')

    erros = []
    if len(nova_senha) < 8:
        erros.append("A nova senha deve ter no mínimo 8 caracteres.")
    if not any(char.isdigit() for char in nova_senha):
        erros.append("A nova senha deve conter pelo menos um número.")
    
    caracteres_especiais = "!@#$%^&*()-+=_"
    if not any(char in caracteres_especiais for char in nova_senha):
        erros.append("A nova senha deve conter um caractere especial (ex: @, #, !).")

    if len(erros) > 0:
        mensagem = " | ".join(erros)
        return template('settings', erro=mensagem)

    senha_atual_hash = hashlib.sha256(senha_atual.encode()).hexdigest()

    dao = UsuarioDAO()
    usuarios = dao.listar()
    usuario_atual = next((u for u in usuarios if u['gmail'] == usuario_gmail), None)

    if usuario_atual and usuario_atual['senha_hash'] == senha_atual_hash:
        nova_senha_hash = hashlib.sha256(nova_senha.encode()).hexdigest()

        novo_user = Usuario(
            id=usuario_atual['id'],
            nome=usuario_atual['nome'],
            gmail=usuario_atual['gmail'],
            senha_hash=nova_senha_hash
        )
        dao.atualizar(usuario_atual['id'], novo_user)
        return template('settings', msg="Senha alterada com sucesso!")
    else:
        return template('settings', erro="Senha atual incorreta!")

@settings_app.post('/configuracoes/delete')
def delete_account():
    usuario_gmail = request.get_cookie("usuario_logado", secret='chave_secreta_do_projeto')
    if not usuario_gmail: return redirect('/login')

    print(f"DEBUG: Tentando deletar conta com cookie: {usuario_gmail}")

    dao = UsuarioDAO()
    usuarios = dao.listar()
    usuario_atual = next((u for u in usuarios if u['gmail'] == usuario_gmail), None)

    if usuario_atual:
        dao.deletar(usuario_atual['id'])
        response.delete_cookie("usuario_logado", path='/')
        print("DEBUG: Conta deletada com sucesso.")
        return redirect('/login')
    
    print("DEBUG: ERRO - Usuário do cookie não encontrado no banco (possível erro de sincronia).")
    return redirect('/configuracoes')

settings_controller = settings_app