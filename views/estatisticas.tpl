<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Estatísticas - StudyFlow</title>
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
        .chart-card { background: white; padding: 25px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); margin-bottom: 30px; }
        .chart-card h3 { margin-top: 0; border-bottom: 1px solid #eee; padding-bottom: 10px; margin-bottom: 20px; }
        canvas { width: 100% !important; height: 300px !important; }
    </style>
</head>
<body>
    <div class="sidebar">
        <div class="logo-area">
            <img src="/static/img/Logo.png">
        </div>
        <a href="/home" class="menu-item"><i class="fas fa-home"></i> Início</a>
        <a href="/estatisticas" class="menu-item active"><i class="fas fa-chart-bar"></i> Estatísticas</a>
        <a href="/configuracoes" class="menu-item"><i class="fas fa-cog"></i> Configurações</a>
        <a href="/logout" class="menu-item logout"><i class="fas fa-sign-out-alt"></i> Sair</a>
    </div>

    <div class="content">
        <h1>Estatísticas</h1>

        % if defined('msg') and msg:
            <div class="alert alert-success">{{msg}}</div>
        % end
        % if defined('erro') and erro:
            <div class="alert alert-error">{{erro}}</div>
        % end

        <div class="chart-card">
            <h3>Horas de estudo nos últimos 7 dias</h3>
            <canvas id="chartDia"></canvas>
        </div>

        <div class="chart-card">
            <h3>Horas de estudo na semana passada</h3>
            <canvas id="chartSemana"></canvas>
        </div>

        <div class="chart-card">
            <h3>Horas de estudo nos últimos meses</h3>
            <canvas id="chartMeses"></canvas>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        function padArrayToLength(arr, len, padValue) {
            const out = arr.slice();
            while (out.length < len) out.push(padValue);
            return out;
        }

        function sortLabelsAndValuesYYYYMM(labels, values) {
            const pairs = labels.map((lab, i) => ({ lab, val: values[i] }))
                .filter(p => p.lab !== undefined && p.lab !== null);

            pairs.forEach(p => {
                if (/^\d{4}-\d{2}-\d{2}$/.test(p.lab)) p.lab = p.lab.slice(0,7);
            });

            pairs.sort((a,b) => a.lab.localeCompare(b.lab));

            return {
                labels: pairs.map(p => p.lab),
                values: pairs.map(p => Number.isFinite(+p.val) ? +p.val : 0)
            };
        }

        async function carregarDados() {
            try {
                const response = await fetch('/estatisticas/dados');
                if (!response.ok) {
                    console.warn('Resposta /estatisticas/dados com status', response.status);
                    return;
                }
                const dados = await response.json();

                const por_dia = (dados && dados.por_dia) ? dados.por_dia : { labels: [], valores: [] };
                const semana = (dados && dados.semana) ? dados.semana : { labels: [], valores: [] };
                const meses = (dados && dados.meses) ? dados.meses : { labels: [], valores: [] };

                por_dia.labels = por_dia.labels || [];
                por_dia.valores = por_dia.valores || [];
                semana.labels = semana.labels || [];
                semana.valores = semana.valores || [];
                meses.labels = meses.labels || [];
                meses.valores = meses.valores || [];

                if (por_dia.labels.length < 7) {
                    por_dia.labels = padArrayToLength(por_dia.labels, 7, '');
                    por_dia.valores = padArrayToLength(por_dia.valores, 7, 0);
                } else if (por_dia.labels.length > 7) {
                    por_dia.labels = por_dia.labels.slice(-7);
                    por_dia.valores = por_dia.valores.slice(-7);
                }

                if (semana.labels.length < 8) {
                    semana.labels = padArrayToLength(semana.labels, 8, '');
                    semana.valores = padArrayToLength(semana.valores, 8, 0);
                } else if (semana.labels.length > 8) {
                    semana.labels = semana.labels.slice(-8);
                    semana.valores = semana.valores.slice(-8);
                }

                const mesesClean = sortLabelsAndValuesYYYYMM(meses.labels, meses.valores);

                if (mesesClean.labels.length !== mesesClean.values.length) {
                    const L = Math.max(mesesClean.labels.length, mesesClean.values.length);
                    mesesClean.labels = padArrayToLength(mesesClean.labels, L, '');
                    mesesClean.values = padArrayToLength(mesesClean.values, L, 0);
                }

                gerarChart('chartDia', por_dia.labels, por_dia.valores);
                gerarChart('chartSemana', semana.labels, semana.valores);
                gerarChart('chartMeses', mesesClean.labels, mesesClean.values);

            } catch (err) {
                console.error('Erro ao carregar estatísticas:', err);
            }
        }

        function gerarChart(id, labels, valores) {
            const numeric = (valores || []).map(v => Number.isFinite(+v) ? +v : 0);

            if ((labels ? labels.length : 0) !== numeric.length) {
                const L = Math.max(labels.length || 0, numeric.length || 0);
                labels = padArrayToLength(labels || [], L, '');
                while (numeric.length < L) numeric.push(0);
            }

            const ctx = document.getElementById(id);
            if (!ctx) {
                console.warn('Canvas não encontrado:', id);
                return;
            }

            if (ctx._chartInstance) {
                ctx._chartInstance.destroy();
            }

            ctx._chartInstance = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Horas',
                        data: numeric,
                        backgroundColor: '#247B7B'
                    }]
                },
                options: { responsive: true, maintainAspectRatio: false }
            });
        }

        carregarDados();
    </script>

</body>
</html>
