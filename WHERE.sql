-- Databricks notebook source
SELECT * FROM silver_olist.pedido
WHERE descSituacao = 'delivered'
LIMIT 100

-- leia-se: selecioone todas colunas da tabela
--silver_olist.pedidos onde a situacao é delivered



-- COMMAND ----------

SELECT * FROM silver_olist.pedido
WHERE descSituacao = 'canceled'
LIMIT 100

-- leia-se: selecioone todas colunas da tabela
--silver_olist.pedidos onde a situacao é canceled

-- COMMAND ----------

SELECT
  *
FROM
  silver_olist.pedido
WHERE
  descSituacao = 'canceled'
  AND year(dtPedido) = '2018'

-- COMMAND ----------

SELECT
  *
FROM
  silver_olist.pedido
WHERE
  (descSituacao = 'canceled' OR descSituacao = 'shipped') AND
  year(dtPedido) = '2018'

-- COMMAND ----------

SELECT
  *
FROM
  silver_olist.pedido
WHERE
  descSituacao IN ('canceled', 'shipped')
  AND year(dtPedido) = '2018'

-- COMMAND ----------

SELECT
  *, datediff(dtEstimativaEntrega, DtAprovado) AS date_diff
FROM
  silver_olist.pedido
WHERE
  descSituacao IN ('canceled', 'shipped')
  AND year(dtPedido) = '2018'
  AND datediff(dtEstimativaEntrega, DtAprovado) > 30
