-- models/intermediate/int_clima_diario.sql
WITH base AS (
    SELECT *
    FROM {{ ref('stg_clima') }}
),

enriched AS (
    SELECT
        id_cidade,
        cidade,
        data,
        temperatura,
        temperatura_max,
        temperatura_min,
        sensacao,
        sensacao_max,
        sensacao_min,
        umidade,
        precipitacao,
        prob_precipitacao,
        area_precipitada,
        rajada_vento,
        velocidade_vento,
        direcao_vento,
        indice_uv,
        cobertura_nuvens,
        visibilidade,
        nascer_sol,
        por_sol,
        fase_lua_valor,
        {{ classify_moon_phase('fase_lua_valor') }} AS fase_lua_nome,
        condicao,
        descricao,
        fonte_dados,
        ROUND(temperatura_max - temperatura_min, 2) AS amplitude_termica,
        ROUND(precipitacao * (prob_precipitacao / 100), 2) AS precipitacao_esperada,
        TRY(ROUND(
            CAST(date_diff('minute', parse_datetime(nascer_sol, 'HH:mm:ss'), parse_datetime(por_sol, 'HH:mm:ss')) / 60.0 AS DOUBLE), 2)) AS horas_sol,
        load_datetime

    FROM base
)

SELECT *
FROM enriched