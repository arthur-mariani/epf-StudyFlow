<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Home - StudyFlow</title>

    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: Arial, sans-serif; }

        body {
            background-color: #ffffff;
            color: #000;
            display: flex;
        }

        .sidebar {
            width: 260px;
            background: #f7f7f7;
            border-right: 1px solid #ddd;
            position: fixed;
            left: -260px;
            top: 0;
            height: 100%;
            padding: 25px;
            transition: 0.3s ease;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            z-index: 2000;
        }

        .sidebar.open { left: 0; }

        .sidebar-close {
            position: absolute;
            top: 15px;
            left: 20px;
            width: 40px;
            height: 40px;
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: 0.2s;
        }

        .sidebar-close:hover {
            background-color: rgba(0,0,0,0.1);
        }

        .sidebar-logo {
            position: absolute;
            top: 15px;
            left: 75px;
            height: 45px;
        }

        .menu a, .menu-bottom a {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 14px 0;
            text-decoration: none;
            font-size: 16px;
            color: #000;
            border-radius: 6px;
            transition: 0.2s;
        }

        .menu a:hover,
        .menu-bottom a:hover {
            background-color: rgba(0,0,0,0.08);
            padding-left: 8px;
        }

        .menu img, .menu-bottom img {
            width: 22px;
            height: 22px;
        }

        .topbar {
            width: 100%;
            height: 70px;
            background: #ffffff;
            border-bottom: 1px solid #ddd;
            display: flex;
            align-items: center;
            padding: 0 20px;
            gap: 15px;
            position: fixed;
            top: 0;
            z-index: 1500;
        }

        .menu-btn {
            width: 40px;
            height: 40px;
            border-radius: 6px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: 0.2s;
        }

        .menu-btn:hover {
            background-color: rgba(0,0,0,0.1);
        }

        .menu-btn img {
            width: 28px;
            height: 28px;
        }

        .logo {
            height: 45px;
        }

        .username {
            margin-left: auto;
            font-size: 15px;
            color: #000;
        }

        .content {
            margin-top: 90px;
            padding: 20px;
            width: 100%;
        }

        h1 { color: #247B7B; margin-bottom: 10px; }

    </style>
</head>
<body>

    <div class="sidebar" id="sidebar">

        <div class="sidebar-close" onclick="toggleSidebar()">
            <img src="/static/img/Menulateral.png" style="transform: rotate(180deg); width:26px; height:26px;">
        </div>

        <img src="/static/img/Logo2.png" class="sidebar-logo">

        <div class="menu" style="margin-top:50px;">
            <a href="/estatisticas" class="menu-item">
                <img src="/static/img/Estatisticas.png" alt="Estatísticas">
                Estatísticas
            </a>
            <a href="/configuracoes" class="menu-item">
                <img src="/static/img/Engrenagem.png" alt="Configurações">
                Configurações
            </a>
        </div>

        <div class="menu-bottom">
            <a href="/logout">
                <img src="/static/img/Logout.png" alt="Logout">
                Logout
            </a>
        </div>
    </div>

    <div class="topbar">
        <div class="menu-btn" onclick="toggleSidebar()">
            <img src="/static/img/Menulateral.png" alt="Menu">
        </div>

        <img src="/static/img/Logo2.png" alt="Logo" class="logo">

        <div class="username">{{user}}</div>
    </div>

    <div class="content">
        <h1>Bem-vindo ao Study Flow!</h1>
        <p>Você está logado como: <strong>{{user}}</strong></p>
    </div>

    <script>
        function toggleSidebar() {
            document.getElementById('sidebar').classList.toggle('open');
        }
    </script>

</body>
</html>
