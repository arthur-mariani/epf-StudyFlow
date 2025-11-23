<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cadastre-se - StudyFlow</title>
    <link rel="icon" href="/static/img/favicon.ico?v=1" type="image/x-icon">

    <style>
        body {
            margin: 0;
            padding: 0;
            background-color: #ffffff; /* fundo branco */
            font-family: Arial, sans-serif;
            color: #000;
        }

        .container {
            width: 100%;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .box {
            width: 380px;
            border: 1px solid #ddd;
            padding: 30px 40px;
            text-align: center;
            background-color: #fff;
            border-radius: 8px;
        }

       .logo-img {
            width: 220px;
            height: auto;
            margin-bottom: 50px;
            display: block;
            margin-left: auto;
            margin-right: auto;
        }

        .title {
            font-size: 22px;
            font-weight: bold;
            margin-bottom: 25px;
            color: #247B7B; /* Usando a cor da sua marca no título também */
        }

        .input-field {
            width: 100%;
            padding: 12px;
            background-color: #fafafa;
            border: 1px solid #ccc;
            border-radius: 4px;
            margin-bottom: 12px;
            font-size: 14px;
            box-sizing: border-box;
        }

        .signup-btn {
            width: 100%;
            background-color: #247B7B; /* Sua cor de marca */
            border: none;
            padding: 12px;
            border-radius: 5px;
            font-weight: bold;
            cursor: pointer;
            color: #fff;
            font-size: 14px;
            margin-top: 10px;
            box-sizing: border-box;
        }

        footer {
            position: fixed;
            bottom: 0;
            left: 0;
            width: 100%;
            text-align: center;
            font-size: 12px;
            color: #777;
            padding: 10px 0;
            background-color: white;
        }
    </style>
</head>

<body>

<div class="container">
    <div class="box">

        <img src="/static/img/logo3.png" alt="StudyFlow Logo" class="logo-img">

        % if defined('error') and error:
            <div style="color: #e74c3c; background-color: #fadbd8; padding: 10px; border-radius: 5px; margin-bottom: 15px; font-size: 14px; border: 1px solid #e74c3c;">
                {{error}}
            </div>
        % end

        % if defined('success') and success:
            <div style="color: #155724; background-color: #d4edda; border: 1px solid #c3e6cb; padding: 10px; border-radius: 5px; margin-bottom: 15px; font-size: 14px; text-align: center;">
                {{success}}
            </div>
            <script>
                // Redireciona para a login após 2 segundos
                setTimeout(function() {
                    window.location.href = "/login";
                }, 2000);
            </script>
        % end

        <form action="/signin" method="POST">
            <input id="input-name" class="input-field" type="text" name="nome" placeholder="Nome completo" value="{{request.forms.get('nome') or ''}}" required>
            
            <input id="input-email" class="input-field" type="text" name="gmail" placeholder="Email" value="{{request.forms.get('gmail') or ''}}" required>
            
            <input id="input-password" class="input-field" type="password" name="senha" placeholder="Senha" required>

            <input id="input-password2" class="input-field" type="password" name="senha2" placeholder="Confirmar Senha" required>

            <button class="signup-btn" type="submit">Cadastrar-se</button>
        </form>

        <p style="text-align: center; font-size: 12px; margin-top: 15px;">
            <a href="/" style="text-decoration: none; color: #247B7B;">Voltar para Home</a>
        </p>

    </div>

</div>

<footer>
        <p>&copy; 2025, StudyFlow. Todos os direitos reservados.</p>
</footer>

</body>
</html>