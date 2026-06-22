-- models/marts/fact_desvio_previsao.sql
{{ config(materialized='table') }}

WITH base AS (
    SELECT *
    FROM {{ ref('int_clima_diario') }}
),

separado AS (
    SELECT
        cidade,
        data,
        temperatura,
        precipitacao,
        sensacao,
        umidade,
        fonte_dados
    FROM base
    WHERE fonte_dados IN ('fcst', 'comb')
),

pivotado AS (
    SELECT
        cidade,
        data,

        MAX(CASE WHEN fonte_dados = 'fcst' THEN temperatura END) AS temperatura_fcst,
        MAX(CASE WHEN fonte_dados = 'comb' THEN temperatura END) AS temperatura_comb,

        MAX(CASE WHEN fonte_dados = 'fcst' THEN precipitacao END) AS precipitacao_fcst,
        MAX(CASE WHEN fonte_dados = 'comb' THEN precipitacao END) AS precipitacao_comb,

        MAX(CASE WHEN fonte_dados = 'fcst' THEN sensacao END) AS sensacao_fcst,
        MAX(CASE WHEN fonte_dados = 'comb' THEN sensacao END) AS sensacao_comb,

        MAX(CASE WHEN fonte_dados = 'fcst' THEN umidade END) AS umidade_fcst,
        MAX(CASE WHEN fonte_dados = 'comb' THEN umidade END) AS umidade_comb

    FROM separado
    GROUP BY cidade, data
),

desvios AS (
    SELECT
        cidade,
        data,

        ROUND(temperatura_fcst - temperatura_comb, 2) AS desvio_temperatura,
        ROUND(precipitacao_fcst - precipitacao_comb, 2) AS desvio_precipitacao,
        ROUND(sensacao_fcst - sensacao_comb, 2) AS desvio_sensacao,
        ROUND(umidade_fcst - umidade_comb, 2) AS desvio_umidade

    FROM pivotado
    WHERE temperatura_fcst IS NOT NULL AND temperatura_comb IS NOT NULL
)

SELECT *
FROM desvios