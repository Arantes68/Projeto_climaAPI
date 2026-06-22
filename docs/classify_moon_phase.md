{% docs classify_moon_phase %}
## 🛠️ Macro: `classify_moon_phase`

Essa macro do dbt classifica o valor da fase da lua retornado pela API Visual Crossing em um nome textual em português, de forma que fique inteligível para dashboards e análises.

## 🔍 Finalidade
Converter o valor numérico da fase da lua (variando entre `0` e `1`) em uma string representando a fase lunar correspondente.

## 🔢 Intervalos usados
| Valor (`moonphase`)        | Nome da fase               |
|----------------------------|----------------------------|
| `0`                        | Lua Nova                  |
| `0 < x < 0.25`             | Crescente Côncava         |
| `0.25`                     | Quarto Crescente          |
| `0.25 < x < 0.5`           | Gibosa Crescente          |
| `0.5`                      | Lua Cheia                 |
| `0.5 < x < 0.75`           | Gibosa Minguante          |
| `0.75`                     | Quarto Minguante          |
| `0.75 < x <= 1`            | Crescente Minguante       |
| Outro                      | Fase Desconhecida         |

## 🧩 Exemplo de uso
```sql
SELECT
  data,
  \{\{ classify_moon_phase('fase_lua_valor') \}\} AS fase_lua_nome
FROM \{\{ ref('int_clima_diario') \}\}
```

## 🛠️ Requisitos
- A coluna `fase_lua_valor` deve conter valores `FLOAT` entre 0 e 1.
- Usar dentro de um modelo SQL do dbt.

---

📚 Baseado na [documentação oficial da Visual Crossing](https://www.visualcrossing.com/resources/documentation/weather-data/weather-data-documentation/#moonphase).
{% enddocs %}