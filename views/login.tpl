<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Entrar - StudyFlow</title>
    <link rel="icon" href="/static/img/favicon.ico?v=1" type="image/x-icon">

    <style>
        body {
            margin: 0;
            padding: 0;
            background-color: #ffffff;
            font-family: Arial, sans-serif; 
            color: #000;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            flex-direction: column;
        }

        .main-wrapper {
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column;
        }

        .box {
            width: 380px;
            border: 1px solid #ddd;
            padding: 30px 40px;
            text-align: center;
            background-color: #fff;
            border-radius: 8px;
            box-sizing: border-box;
        }
        
        .logo-img {
            width: 220px;
            height: auto;
            margin-bottom: 50px;
            display: block;
            margin-left: auto;
            margin-right: auto;
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
            outline: none;
        }

        .input-field:focus {
            border-color: #999;
        }

        .login-btn {
            width: 100%;
            background-color: #247B7B;
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

        .login-btn:hover {
            opacity: 0.9;
        }

        .signup-text {
            font-size: 12px;
            margin: 0;
            margin-top: 15px;
        }

        .signup-link {
            color: #247B7B;
            font-weight: bold;
            text-decoration: none;
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

        .alert-error {
            color: #e74c3c;
            background-color: #fadbd8;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 15px;
            font-size: 14px;
            border: 1px solid #e74c3c;
        }

        .alert-success {
            color: #155724;
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 15px;
            font-size: 14px;
        }
    </style>
</head>

<body>

<div class="main-wrapper">
    
    <div class="box">
        <img src="/static/img/logo3.png" alt="StudyFlow Logo" class="logo-img">

        % if defined('error') and error:
            <div class="alert-error">
                {{error}}
            </div>
        % end

        % if defined('success') and success:
            <div class="alert-success">
                {{success}}
            </div>
            <script>
                // Redireciona para a home após 2 segundos
                setTimeout(function() {
                    window.location.href = "/users";
                }, 2000);
            </script>
        % end

        <form action="/login" method="POST">
            <input class="input-field" type="text" name="gmail" placeholder="Email" value="{{request.forms.get('gmail') or ''}}" required>
            <input class="input-field" type="password" name="senha" placeholder="Senha" required>

            <button class="login-btn" type="submit">Entrar</button>
        </form>

        <p class="signup-text">
            Não tem uma conta? <a href="/signin" class="signup-link">Cadastre-se</a>
        </p>
    </div>
    

</div>

<footer>
        <p>&copy; 2025, StudyFlow. Todos os direitos reservados.</p>
</footer>

</body>
</html>