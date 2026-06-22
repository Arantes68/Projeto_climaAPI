WITH base AS (
    SELECT * 
    FROM {{ source('landing', 'clima') }}
),

renamed AS (
    SELECT
        md5(to_utf8(t.address)) AS id_cidade,
        CAST(t.address AS VARCHAR) AS cidade,
        CAST(element.datetime AS DATE) AS data,
        CAST(element.temp AS DOUBLE) AS temperatura,
        CAST(element.tempmax AS DOUBLE) AS temperatura_max,
        CAST(element.tempmin AS DOUBLE) AS temperatura_min,
        CAST(element.feelslike AS DOUBLE) AS sensacao,
        CAST(element.feelslikemax AS DOUBLE) AS sensacao_max,
        CAST(element.feelslikemin AS DOUBLE) AS sensacao_min,
        CAST(element.humidity AS DOUBLE) AS umidade,
        CAST(element.precip AS DOUBLE) AS precipitacao,
        CAST(element.precipprob AS DOUBLE) AS prob_precipitacao,
        CAST(element.precipcover AS DOUBLE) AS area_precipitada,
        CAST(element.windgust AS DOUBLE) AS rajada_vento,
        CAST(element.windspeed AS DOUBLE) AS velocidade_vento,
        CAST(element.winddir AS DOUBLE) AS direcao_vento,
        CAST(element.uvindex AS INT) AS indice_uv,
        CAST(element.cloudcover AS DOUBLE) AS cobertura_nuvens,
        CAST(element.visibility AS DOUBLE) AS visibilidade,
        CAST(element.sunrise AS VARCHAR) AS nascer_sol,
        CAST(element.sunset AS VARCHAR) AS por_sol,
        CAST(element.moonphase AS DOUBLE) AS fase_lua_valor,
        CAST(element.conditions AS VARCHAR) AS condicao,
        CAST(element.description AS VARCHAR) AS descricao,
        CAST(element.source AS VARCHAR) as fonte_dados,
        CAST(current_timestamp AS VARCHAR) AS load_datetime
    FROM base AS t,
         UNNEST(t.days) WITH ORDINALITY AS day_item (element, idx)
)

SELECT *
FROM renamed