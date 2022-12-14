-- Databricks notebook source
SELECT count(*) FROM silver_olist.pedido

--leia-se selecione TUDO da tabela olist.pedido

-- COMMAND ----------

SELECT idPedido
FROM silver_olist.pedido


--Selecione o idPedido da tabela silver.olist.pedido

-- COMMAND ----------

SELECT
  idPedido,
  descSituacao
FROM
  silver_olist.pedido --Selecione o idPedido e descSituacao da tabela silver.olist.pedido

-- COMMAND ----------

SELECT idPedido, descSituacao
FROM silver_olist.pedido

LIMIT 5

-- COMMAND ----------

SELECT *, 
DATEDIFF(dtEstimativaEntrega, dtEntregue) AS qtDiasPromessaEntrega
FROM silver_olist.pedido
