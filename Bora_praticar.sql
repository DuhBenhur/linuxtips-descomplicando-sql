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

SELECT
  COUNT(*) nrLinhasNaoNulas,
  COUNT(idCliente) AS nrIdClienteNaoNulo, --id de clientes não nulos
  COUNT(distinct idCliente) AS nrIdClienteDistintos,--id de clientes distintos
  COUNT(idClienteUnico) AS nrIdClienteUnico,
  COUNT(DISTINCT idClienteUnico) AS nrIdClienteUnicoDistintos
FROM
  silver_olist.cliente

-- COMMAND ----------

SELECT
  COUNT(*)
FROM
  silver_olist.cliente
WHERE
  descCidade = 'presidente prudente'

-- COMMAND ----------

SELECT
  PERCENTILE(vlPreco, 0.5) AS medianPreco,
  AVG(vlPreco) AS avgPreco,
  MAX(vlPreco) AS maxPreco,
  AVG(vlFrete) AS avgFrete,
  MAX(VlFrete) AS maxVlFrete,
  MIN(VlFrete) AS minVlFrete
FROM
  silver_olist.item_pedido

-- COMMAND ----------

-- MAGIC %md
-- MAGIC 
-- MAGIC GROUP BY

-- COMMAND ----------

SELECT descUF, COUNT(*) AS qtd_cliente
FROM silver_olist.cliente
GROUP BY descUF
ORDER BY qtd_cliente DESC

-- COMMAND ----------

SELECT
  descUF,
  COUNT(*)
FROM
  silver_olist.cliente
GROUP BY
  descUF

-- COMMAND ----------

SELECT
descUF,
COUNT(*)
FROM  silver_olist.cliente
GROUP BY descUF

-- COMMAND ----------

SELECT 
  descUF,
  COUNT(DISTINCT idClienteUnico)
  FROM silver_olist.cliente
  GROUP BY descUF

-- COMMAND ----------


