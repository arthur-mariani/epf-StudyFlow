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
            color: #333;
        }

        .content {
            margin-top: 90px;
            padding: 20px;
            width: 100%;
        }

        h1 { color: #247B7B; margin-bottom: 10px; }

        .dashboard-container {
            display: grid;
            grid-template-columns: 2fr 1fr; /* 2 partes para timer, 1 para ranking */
            gap: 25px;
            max-width: 1200px;
            margin: 0 auto;
        }

        .card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            border: 1px solid #eee;
        }

        .timer-section { text-align: center; display: flex; flex-direction: column; align-items: center; }
        
        .timer-big {
            font-size: 5rem; font-weight: 700; color: #333;
            line-height: 1; font-variant-numeric: tabular-nums;
        }
        
        .timer-small {
            font-size: 2rem;
            font-weight: 600;
            color: #247B7B;
            margin-top: 10px; opacity: 0.5;
            transition: 0.3s;
            font-variant-numeric: tabular-nums;
        }

        .timer-small.active { opacity: 1;
         transform: scale(1.1);
        }

        .controls { margin-top: 20px;
        }

        .controls button {
            padding: 12px 30px;
            font-size: 1.1rem;
            border: none;
            border-radius: 50px;
            cursor: pointer;
            margin: 0 10px;
            font-weight: bold;
            color: white;
        }

        .btn-start { background-color: #247B7B;
        }

        .btn-pause {
            background-color: #f0ad4e;
            display: none;
        }

        .btn-stop  {
            background-color: #d9534f;
            display: none;
        }

        .ranking-list {
            list-style: none;
            margin-top: 15px;
        }

        .ranking-item { 
            display: flex;
            justify-content: space-between; 
            padding: 12px 0;
            border-bottom: 1px solid #f9f9f9; 
        }
        .rank-pos {
            font-weight: bold;
            color: #247B7B;
            margin-right: 10px;
        }

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
        <h1>Painel de Foco</h1>

        <div class="dashboard-container">
            
            <div class="card timer-section">
                <h3 style="color:#888; margin-bottom:15px;">Modo de Estudo</h3>
                
                <select id="modo-selecionado" onchange="mudarModo()" style="padding: 10px; border-radius: 8px; border: 1px solid #ddd; width: 100%; max-width: 300px; margin-bottom: 15px; font-size: 1rem;">
                    <option value="padrao">Pomodoro Convencional (25m / 5m)</option>
                    <option value="editado">Pomodoro Editado (Personalizar)</option>
                    <option value="livre">Modo Livre (Sem Pausa)</option>
                </select>

                <div id="inputs-config" style="display: none; gap: 10px; margin-bottom: 20px;">
                    <input type="number" id="input-estudo" placeholder="Min Estudo" style="padding: 8px; width: 100px; border: 1px solid #ccc; border-radius: 5px;">
                    <input type="number" id="input-pausa" placeholder="Min Pausa" style="padding: 8px; width: 100px; border: 1px solid #ccc; border-radius: 5px;">
                    <button onclick="aplicarConfiguracao()" style="padding: 8px 15px; background: #555; color: white; border: none; border-radius: 5px; cursor: pointer;">OK</button>
                </div>

                <div class="timer-wrapper">
                    <div class="timer-label">TEMPO DE FOCO</div>
                    <div class="timer-big" id="displayBig">25:00</div>
                    
                    <div id="box-pausa"> <div class="timer-label" style="margin-top: 15px;">TEMPO DE PAUSA</div>
                        <div class="timer-small" id="displaySmall">05:00</div>
                    </div>
                </div>

                <div class="controls">
                    <button class="btn-start" onclick="iniciar()" id="btnStart">INICIAR</button>
                    <button class="btn-pause" onclick="pausar()" id="btnPause">PAUSAR</button>
                    <button class="btn-stop" onclick="encerrar()" id="btnStop">ENCERRAR</button>
                </div>
            </div>

            <div class="card">
                <h3>🏆 Ranking Semanal</h3>
                <ul class="ranking-list">
                    <li class="ranking-item">
                        <div><span class="rank-pos">1º</span> Ana Silva</div>
                        <strong>12h 30m</strong>
                    </li>
                    <li class="ranking-item">
                        <div><span class="rank-pos">2º</span> Carlos (Você)</div>
                        <strong>08h 15m</strong>
                    </li>
                    </ul>
            </div>

        </div>
    </div>

    <script>
    let intervalo = null;
    let estado = "PARADO";
    let tempoEstudoConfig = 25 * 60;
    let tempoPausaConfig = 5 * 60;
    let contadorEstudo = tempoEstudoConfig;
    let contadorPausa = tempoPausaConfig;
    let totalEstudadoSessao = 0;

    const displayBig = document.getElementById('displayBig');
    const displaySmall = document.getElementById('displaySmall');
    const boxPausa = document.getElementById('box-pausa');
    const inputsDiv = document.getElementById('inputs-config');
    const inputEstudo = document.getElementById('input-estudo');
    const inputPausa = document.getElementById('input-pausa');
    const modoSelect = document.getElementById('modo-selecionado');
    const btnStart = document.getElementById('btnStart');
    const btnPause = document.getElementById('btnPause');
    const btnStop = document.getElementById('btnStop');

    window.onload = function() {
        atualizarTela();
    };

    function mudarModo() {
        const modo = modoSelect.value;
        pausar();
        resetarVisual();

        if (modo === 'padrao') {
            inputsDiv.style.display = 'none';
            boxPausa.style.display = 'block';
            tempoEstudoConfig = 25 * 60;
            tempoPausaConfig = 5 * 60;
        } else if (modo === 'editado') {
            inputsDiv.style.display = 'flex';
            inputsDiv.style.justifyContent = 'center';
            boxPausa.style.display = 'block';
            inputPausa.style.display = 'block';
        } else if (modo === 'livre') {
            inputsDiv.style.display = 'flex';
            inputsDiv.style.justifyContent = 'center';
            boxPausa.style.display = 'none';
            inputPausa.style.display = 'none';
        }

        if (modo === 'padrao') {
            contadorEstudo = tempoEstudoConfig;
            contadorPausa = tempoPausaConfig;
            atualizarTela();
        }
    }

    function aplicarConfiguracao() {
        const minEstudo = parseInt(inputEstudo.value);
        const minPausa = parseInt(inputPausa.value);

        if (isNaN(minEstudo) || minEstudo <= 0) {
            alert("Por favor, digite um tempo de estudo válido!");
            return;
        }

        tempoEstudoConfig = minEstudo * 60;

        if (modoSelect.value === 'livre') {
            tempoPausaConfig = 0;
        } else {
            tempoPausaConfig = (isNaN(minPausa) ? 5 : minPausa) * 60;
        }

        contadorEstudo = tempoEstudoConfig;
        contadorPausa = tempoPausaConfig;
        atualizarTela();

        alert("Tempo configurado com sucesso! Pode iniciar.");
    }

    function formatar(s) {
        const m = Math.floor(s / 60).toString().padStart(2, '0');
        const seg = (s % 60).toString().padStart(2, '0');
        return `${m}:${seg}`;
    }

    function atualizarTela() {
        if (displayBig) displayBig.innerText = formatar(contadorEstudo);
        if (displaySmall) displaySmall.innerText = formatar(contadorPausa);
    }

    function iniciar() {
        if (estado === "PARADO" || estado === "PAUSA") {
            estado = "ESTUDANDO";
        }

        btnStart.style.display = 'none';
        btnPause.style.display = 'inline-block';
        btnPause.innerText = "PAUSAR";
        btnStop.style.display = 'inline-block';

        modoSelect.disabled = true;

        if (intervalo) clearInterval(intervalo);

        intervalo = setInterval(() => {
            if (estado === "ESTUDANDO") {
                if (contadorEstudo > 0) {
                    contadorEstudo--;
                    totalEstudadoSessao++;

                    displayBig.style.opacity = "1";
                    displaySmall.classList.remove('active');
                } else {
                    if (modoSelect.value === 'livre') {
                        encerrar();
                    } else {
                        estado = "PAUSA";
                        tocarAlerta();
                    }
                }
            } else if (estado === "PAUSA") {
                if (contadorPausa > 0) {
                    contadorPausa--;
                    displayBig.style.opacity = "0.3";
                    displaySmall.classList.add('active');
                } else {
                    pausar();
                    tocarAlerta();
                    contadorEstudo = tempoEstudoConfig;
                    contadorPausa = tempoPausaConfig;
                }
            }

            atualizarTela();
        }, 1000);
    }

    function pausar() {
        clearInterval(intervalo);
        intervalo = null;

        btnStart.style.display = 'inline-block';
        btnStart.innerText = "RETOMAR";
        btnPause.style.display = 'none';
    }

    function encerrar() {
        clearInterval(intervalo);
        intervalo = null;

        if (totalEstudadoSessao < 5) {
            alert("Sessão muito curta (menos de 5s). Não será salva.");
            resetarVisual();
            return;
        }

        let nomeModo = "Pomodoro Padrão";
        if (modoSelect.value === 'editado') nomeModo = "Pomodoro Personalizado";
        if (modoSelect.value === 'livre') nomeModo = "Modo Livre";

        btnStop.innerText = "SALVANDO...";
        btnStop.disabled = true;

        fetch('/salvar_sessao', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    segundos: totalEstudadoSessao,
                    materia: nomeModo
                })
            })
            .then(r => r.json())
            .then(data => {
                if (data.status === 'sucesso') {
                    alert(`Sessão salva com sucesso! Tempo total: ${formatar(totalEstudadoSessao)}`);
                } else {
                    alert("Erro ao salvar: " + data.msg);
                }
                resetarVisual();
            })
            .catch(e => {
                console.error(e);
                alert("Erro de conexão com o servidor.");
                resetarVisual();
            });
    }

    function resetarVisual() {
        estado = "PARADO";
        totalEstudadoSessao = 0;

        contadorEstudo = tempoEstudoConfig;
        contadorPausa = tempoPausaConfig;
        atualizarTela();

        displaySmall.classList.remove('active');
        displayBig.style.opacity = "1";

        btnStart.innerText = "INICIAR";
        btnStart.style.display = 'inline-block';
        btnPause.style.display = 'none';
        btnStop.style.display = 'none';
        btnStop.innerText = "ENCERRAR";
        btnStop.disabled = false;

        modoSelect.disabled = false;
    }

    function tocarAlerta() {
        if (estado === "PAUSA") alert("Fim do foco! Hora da pausa.");
        else alert("Fim da pausa! Hora de voltar.");
    }

    function toggleSidebar() {
        document.getElementById('sidebar').classList.toggle('open');
    }
</script>

</body>
</html>
