<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Home - Study Flow</title>
    <style>
        body { font-family: sans-serif; text-align: center; padding: 50px; }
        .card { border: 1px solid #ccc; padding: 20px; display: inline-block; border-radius: 8px; }
        .btn { background: red; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="card">
        <h1>Bem-vindo ao Study Flow!</h1>
        <p>Você está logado como: <strong>{{user}}</strong></p>
        
        <br><br>
        
        <a href="/logout" class="btn">Sair (Logout)</a>
    </div>
</body>
</html>