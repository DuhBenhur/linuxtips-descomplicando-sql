-- Databricks notebook source
SELECT
  *,
  CASE
    WHEN descUF = 'SP' THEN 'paulista'
    WHEN descUF = 'RJ' THEN 'fluminense'
    WHEN descUF IN ('PR', 'pr') THEN 'paranaense'
    ELSE 'outros'
  END AS descNacionalidade,
  CASE
    WHEN descCidade  LIKE '%sao%' THEN 'Tem são no nome'
    ELSE 'Não tem são no nome' END AS descCidadeSao
    FROM
      silver_olist.cliente

-- COMMAND ----------

-- MAGIC %md
-- MAGIC 
-- MAGIC Selecione todosos clientes Paulistanos

-- COMMAND ----------

SELECT * FROM silver_olist.cliente
WHERE descCidade = 'sao paulo'

-- COMMAND ----------

SELECT
  *
FROM
  silver_olist.produto
WHERE
  descCategoria IN ('perfumaria', 'bebes')
  AND vlAlturaCm > 5

-- COMMAND ----------


