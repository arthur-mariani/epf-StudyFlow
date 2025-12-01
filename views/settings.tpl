<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Configurações - StudyFlow</title>
    <link rel="icon" href="/static/img/favicon.ico?v=1" type="image/x-icon">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        body { margin: 0; font-family: 'Segoe UI', Arial, sans-serif; display: flex; height: 100vh; background-color: #f4f7f6; color: #333; }
        
        .sidebar { width: 250px; background-color: #fff; border-right: 1px solid #ddd; padding: 20px; display: flex; flex-direction: column; }
        .logo-area { display: flex; align-items: center; gap: 10px; margin-bottom: 15px; }
        .logo-area img { width: 120px; }
        .menu-item { display: flex; align-items: center; padding: 12px 15px; color: #555; text-decoration: none; border-radius: 8px; margin-bottom: 8px; transition: 0.3s; font-size: 16px; }
        .menu-item:hover { background-color: #e0f2f1; color: #247B7B; }
        .menu-item.active { background-color: #247B7B; color: white; }
        .menu-item i { margin-right: 12px; width: 20px; text-align: center; }
        
        .logout { margin-top: auto; color: #e74c3c; }
        .logout:hover { background-color: #fadbd8; color: #c0392b; }

        .content { flex: 1; padding: 40px; overflow-y: auto; }
        
        h1 { margin-top: 0; color: #247B7B; margin-bottom: 30px; }

        /* Estilo dos Cartões de Configuração */
        .config-card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            margin-bottom: 30px;
            max-width: 600px;
        }

        .config-card h3 { margin-top: 0; border-bottom: 1px solid #eee; padding-bottom: 10px; margin-bottom: 20px; }

        label { display: block; margin-bottom: 8px; font-weight: 500; font-size: 14px; }
        input { width: 100%; padding: 10px; margin-bottom: 15px; border: 1px solid #ddd; border-radius: 5px; box-sizing: border-box; }

        .btn { padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; font-weight: bold; transition: 0.2s; }
        .btn-primary { background-color: #247B7B; color: white; }
        .btn-primary:hover { background-color: #1b5e5e; }
        
        .btn-danger { background-color: #fff; color: #e74c3c; border: 1px solid #e74c3c; }
        .btn-danger:hover { background-color: #e74c3c; color: white; }

        /* Mensagens de Feedback */
        .alert { padding: 15px; margin-bottom: 20px; border-radius: 5px; max-width: 600px; }
        .alert-success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .alert-error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }

    </style>
</head>
<body>

    <div class="sidebar">
          <div class="logo-area">
            <img src="/static/img/Logo.png">
        </div>
        <a href="/home" class="menu-item"><i class="fas fa-home"></i> Início</a>
        <a href="/estatisticas" class="menu-item"><i class="fas fa-chart-bar"></i> Estatísticas</a>
        <a href="/configuracoes" class="menu-item active"><i class="fas fa-cog"></i> Configurações</a>
        <a href="/logout" class="menu-item logout"><i class="fas fa-sign-out-alt"></i> Sair</a>
    </div>

    <div class="content">
        <h1>Configurações</h1>

        % if defined('msg') and msg:
            <div class="alert alert-success">{{msg}}</div>
        % end
        % if defined('erro') and erro:
            <div class="alert alert-error">{{erro}}</div>
        % end

        <div class="config-card">
            <h3>Alterar Email</h3>
            <form action="/configuracoes/email" method="POST">
                <label>Novo Email:</label>
                <input type="text" name="novo_gmail" placeholder="exemplo@gmail.com" required>
                
                <label>Senha Atual (para confirmar):</label>
                <input type="password" name="senha_atual" required>
                
                <button type="submit" class="btn btn-primary">Salvar Novo Email</button>
            </form>
        </div>

        <div class="config-card">
            <h3>Alterar Senha</h3>
            <form action="/configuracoes/senha" method="POST">
                <label>Senha Atual:</label>
                <input type="password" name="senha_atual" required>
                
                <label>Nova Senha:</label>
                <input type="password" name="nova_senha" required>
                
                <button type="submit" class="btn btn-primary">Atualizar Senha</button>
            </form>
        </div>

        <div class="config-card" style="border: 1px solid #fadbd8;">
            <h3 style="color: #c0392b;">Zona de Perigo</h3>
            <p style="font-size: 14px; color: #666; margin-bottom: 20px;">
                Ao deletar sua conta, todos os seus dados de estudo serão perdidos permanentemente. Essa ação não pode ser desfeita.
            </p>
            <form action="/configuracoes/delete" method="POST" onsubmit="return confirm('Tem certeza ABSOLUTA que deseja deletar sua conta?');">
                <button type="submit" class="btn btn-danger">Deletar Minha Conta</button>
            </form>
        </div>

    </div>

</body>
</html>