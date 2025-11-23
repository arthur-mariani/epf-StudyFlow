<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cadastro - StudyFlow</title>

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

        <form action="/signin" method="POST">
            <input id="input-name" class="input-field" type="text" name="nome" placeholder="Nome completo" required>
            
            <input id="input-email" class="input-field" type="text" name="gmail" placeholder="Email" required>
            
            <input id="input-password" class="input-field" type="password" name="senha" placeholder="Senha" required>
            <input id="input-password2" class="input-field" type="password" name="senha2" placeholder="Confirmar Senha" required>
            <button class="signup-btn" type="submit">Cadastrar-se</button>
        </form>

    </div>

</div>

</body>
</html>