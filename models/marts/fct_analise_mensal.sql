WITH base AS (
    SELECT *
    FROM {{ ref('int_clima_diario') }}
    WHERE fonte_dados = 'comb'
),

agregados AS (
    SELECT
        id_cidade,
        TRIM(cidade) AS cidade,
        date_trunc('month', data) AS mes,
        COUNT(*) AS dias_com_dados,
        ROUND(AVG(temperatura), 2) AS media_temperatura,
        ROUND(AVG(umidade), 2) AS media_umidade,
        ROUND(AVG(precipitacao), 2) AS media_precipitacao,
        ROUND(AVG(precipitacao_esperada), 2) AS media_precipitacao_esperada,
        ROUND(SUM(CASE WHEN precipitacao > 0 THEN 1 ELSE 0 END), 0) AS dias_com_chuva,
        ROUND(AVG(amplitude_termica), 2) AS media_amplitude_termica,
        ROUND(AVG(horas_sol), 2) AS media_horas_sol,
        ROUND(AVG(indice_uv), 2) AS media_uv
    FROM base
    GROUP BY id_cidade, TRIM(cidade), date_trunc('month', data)
),

frequencia_condicao AS (
    SELECT
        id_cidade,
        date_trunc('month', data) AS mes,
        condicao,
        COUNT(*) AS ocorrencias,
        ROW_NUMBER() OVER (PARTITION BY id_cidade, date_trunc('month', data) ORDER BY COUNT(*) DESC) AS ordem
    FROM base
    GROUP BY id_cidade, date_trunc('month', data), condicao
),

condicao_mais_comum AS (
    SELECT id_cidade, mes, condicao AS condicao_mais_frequente
    FROM frequencia_condicao
    WHERE ordem = 1
),

frequencia_lua AS (
    SELECT
        id_cidade,
        date_trunc('month', data) AS mes,
        fase_lua_nome,
        COUNT(*) AS ocorrencias,
        ROW_NUMBER() OVER (PARTITION BY id_cidade, date_trunc('month', data) ORDER BY COUNT(*) DESC) AS ordem
    FROM base
    GROUP BY id_cidade, date_trunc('month', data), fase_lua_nome
),

lua_mais_comum AS (
    SELECT id_cidade, mes, fase_lua_nome AS lua_mais_comum
    FROM frequencia_lua
    WHERE ordem = 1
)

SELECT
    a.cidade,
    a.mes,
    a.dias_com_dados,
    a.media_temperatura,
    a.media_umidade,
    a.media_precipitacao,
    a.media_precipitacao_esperada,
    a.dias_com_chuva,
    a.media_amplitude_termica,
    a.media_horas_sol,
    a.media_uv,
    c.condicao_mais_frequente,
    l.lua_mais_comum
FROM agregados a
LEFT JOIN condicao_mais_comum c ON a.id_cidade = c.id_cidade AND a.mes = c.mes
LEFT JOIN lua_mais_comum l ON a.id_cidade = l.id_cidade AND a.mes = l.mes