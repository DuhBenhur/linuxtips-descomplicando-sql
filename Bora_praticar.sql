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

-- 06 Lista de pedidos feitosem dezembro de 2017 e entregues  com atraso
SELECT
  *
FROM
  silver_olist.pedido
WHERE
  YEAR(dtPedido) = 2017
  AND MONTH(dtPedido) = 12
  AND descSituacao = 'delivered'
  AND date(dtEntregue) > date(dtEstimativaEntrega)

-- COMMAND ----------

--08 Lista de pedidos com 2 ou mais parcelas menores que R$20,00
SELECT * ,
ROUND(vlPagamento / nrPacelas,2) AS vlParcela
FROM silver_olist.pagamento_pedido
WHERE nrPacelas >= 2
AND vlPagamento / nrPacelas < 20

-- COMMAND ----------

SELECT
  *,
  vlPreco + vlFrete as vlTotal,
  Round(vlFrete / (vlPreco + vlFrete), 2) AS pctFrete,
  CASE
    WHEN Round(vlFrete / (vlPreco + vlFrete), 2) <= 0.1 THEN '10%'
    WHEN Round(vlFrete / (vlPreco + vlFrete), 2) <= 0.25 THEN '10% a 25%'
    WHEN Round(vlFrete / (vlPreco + vlFrete), 2) <= 0.5 THEN '25% a 50%'
    ELSE '+50%'
  END AS descFretePct
FROM
  silver_olist.item_pedido

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ORDER BY

-- COMMAND ----------

SELECT
descUF,
COUNT(DISTINCT idClienteUnico) AS qtClienteEstado
FROM silver_olist.cliente
GROUP BY descUF
ORDER BY qtClienteEstado

-- COMMAND ----------

SELECT
descUF,
COUNT(DISTINCT idClienteUnico) AS qtClienteEstado
FROM silver_olist.cliente
GROUP BY descUF
ORDER BY qtClienteEstado DESC

-- COMMAND ----------

SELECT
  descUF,
  COUNT(DISTINCT idClienteUnico) AS qtClienteEstado
FROM
  silver_olist.cliente
GROUP BY
  descUF
ORDER BY
  COUNT(DISTINCT idClienteUnico) DESC 

-- COMMAND ----------

SELECT
  descUF,
  COUNT(DISTINCT idClienteUnico) AS qtClienteEstado
FROM
  silver_olist.cliente
GROUP BY
  descUF
ORDER BY
  COUNT(DISTINCT idClienteUnico) DESC
LIMIT
  1

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ORDER BY

-- COMMAND ----------

SELECT
  descUF,
  COUNT(idVendedor) AS qtVendedor
FROM
  silver_olist.vendedor
WHERE
  descUF IN ('SP', 'MG', 'RJ', 'ES')
GROUP BY
  descUF
HAVING
  qtVendedor >= 100
ORDER by
  qtVendedor DESC

-- COMMAND ----------

-- MAGIC %md
-- MAGIC 
-- MAGIC JOINS

-- COMMAND ----------

SELECT
  T1.*,
  T2.descUF
FROM
  silver_olist.pedido AS T1
  LEFT JOIN silver_olist.cliente AS T2 ON T1.idCliente = T2.idCliente

-- COMMAND ----------

-- Os clientes de qual estado pagam mais fretes?

SELECT T1.idPedido,
T1.vlFrete,
T2.idCliente,
T3.*

FROM silver_olist.item_pedido AS T1
LEFT JOIN silver_olist.pedido AS T2
on T1.idPedido = T2.idPedido
LEFT JOIN silver_olist.cliente AS T3
ON T2.idCliente = T3.idCliente


-- COMMAND ----------


SELECT 
T3.descUF,
ROUND(AVG(T1.vlFrete),2) AS avgFrete

FROM silver_olist.item_pedido AS T1
LEFT JOIN silver_olist.pedido AS T2
on T1.idPedido = T2.idPedido
LEFT JOIN silver_olist.cliente AS T3
ON T2.idCliente = T3.idCliente
GROUP BY T3.descUF
ORDER BY AVG(T1.vlFrete) DESC

-- COMMAND ----------

SELECT
  T3.descUF,
  ROUND(AVG(T1.vlFrete), 2) AS avgFrete
FROM
  silver_olist.item_pedido AS T1
  LEFT JOIN silver_olist.pedido AS T2 on T1.idPedido = T2.idPedido
  LEFT JOIN silver_olist.cliente AS T3 ON T2.idCliente = T3.idCliente
GROUP BY
  T3.descUF
HAVING
  avgFrete < 40
ORDER BY
  avgFrete DESC

-- COMMAND ----------

---Lista de VENDEDORES QUE ESTÃO DO ESTADO COM MAIS CLIENTE
SELECT
  idVendedor, descUF
FROM
  silver_olist.vendedor
WHERE
  descUF = (
    SELECT
      descUF
    FROM
      silver_olist.cliente
    GROUP BY
      descUF
    ORDER BY
      COUNT(DISTINCT idCLienteUnico) DESC
    LIMIT
      1
  )

-- COMMAND ----------

---Lista de VENDEDORES QUE ESTÃO DO ESTADO COM MAIS CLIENTE
SELECT
  idVendedor, descUF
FROM
  silver_olist.vendedor
WHERE
  descUF = (
    SELECT
      descUF
    FROM
      silver_olist.cliente
    GROUP BY
      descUF
    ORDER BY
      COUNT(DISTINCT idCLienteUnico) DESC
    LIMIT
      1
  )

-- COMMAND ----------

WITH tb_estados AS (
  SELECT
    descUF
  FROM
    silver_olist.cliente
  GROUP BY
    descUF
  ORDER BY
    COUNT(DISTINCT idCLienteUnico) DESC
  LIMIT
    2
),
tb_vendedores AS (
SELECT
  idVendedor,
  descUF
FROM
  silver_olist.vendedor
WHERE
  descUF in (
    SELECT
      descUF
    FROM
      tb_estados
  ))
  
  SELECT * FROM tb_vendedores

-- COMMAND ----------

WITH tb_pedido_nota AS (
  SELECT
    T1.idVendedor,
    vlNota
  FROM
    silver_olist.item_pedido AS T1
    LEFT JOIN silver_olist.avaliacao_pedido AS T2 ON T1.idPedido = T2.idPedido
),
tb_avg_vendedor AS (
  SELECT
    idVendedor,
    AVG(vlNota)
  FROM
    tb_pedido_nota
  GROUP BY
    idvendedor
)
SELECT
  *
FROM
  tb_avg_vendedor
),
tb_vendedor_estado AS (
  SELECT
    t1.*,
    t2.descUF
  FROM
    tb_avg_vendedor AS T1
    LEFT JOIN silver_olist.vendedor
)

-- COMMAND ----------

-- LISTA DE VENDEDORES QUE ESTÃO NO ESTADO COM MAIS CLIENTES


SELECT idVendedor, descUF
FROM silver_olist.vendedor
WHERE descUF = (

  SELECT descUF
  FROM silver_olist.cliente
  GROUP BY descUF
  ORDER BY COUNT(DISTINCT idClienteUnico) DESC
  LIMIT 1

)

-- COMMAND ----------

-- LISTA DE VENDEDORES QUE ESTÃO NOS 2 ESTADOS COM MAIS CLIENTES

SELECT idVendedor, descUF
FROM silver_olist.vendedor
WHERE descUF IN (

  SELECT descUF
  FROM silver_olist.cliente
  GROUP BY descUF
  ORDER BY COUNT(DISTINCT idClienteUnico) DESC
  LIMIT 2

)

-- COMMAND ----------

WITH tb_estados AS (

  SELECT descUF
  FROM silver_olist.cliente
  GROUP BY descUF
  ORDER BY COUNT(DISTINCT idClienteUnico) DESC
  LIMIT 2

),

tb_vendedores AS (
  SELECT idVendedor, descUF
  FROM silver_olist.vendedor
  WHERE descUF IN (SELECT descUF FROM tb_estados)
)

SELECT *
FROM tb_vendedores

-- COMMAND ----------

-- NOTA MÉDIA DOS PEDIDOS DOS VENDEDORES DE CADA ESTADO

WITH tb_pedido_nota AS (

  SELECT T1.idVendedor, T2.vlNota
  FROM silver_olist.item_pedido AS T1

  LEFT JOIN silver_olist.avaliacao_pedido AS T2
  ON T1.idPedido = T2.idPedido
),

tb_avg_vendedor AS (

  SELECT idVendedor,
         AVG(vlNota) as avgNotaVendedor
  FROM tb_pedido_nota
  GROUP BY idVendedor
),

tb_vendedor_estado AS (

  SELECT T1.*,
         T2.descUF
  FROM tb_avg_vendedor AS T1
  LEFT JOIN silver_olist.vendedor AS T2
  ON T1.idVendedor = T2.idVendedor

)
SELECT descUF,
       AVG(avgNotaVendedor) AS avgNotaEstado

FROM tb_vendedor_estado

GROUP BY descUF
ORDER BY avgNotaEstado DESC

-- COMMAND ----------

-- DBTITLE 1,Windows function
WITH tb_vendas_vendedores AS (

  SELECT 
        idVendedor,
        COUNT(*) As qtVendas

  FROM silver_olist.item_pedido

  GROUP BY idVendedor
  ORDER BY qtVendas DESC

),

tb_row_number AS (

  SELECT T1.*,
         T2.descUf,
         ROW_NUMBER() OVER (PARTITION BY T2.descUf ORDER BY qtVendas DESC) AS RN

  FROM tb_vendas_vendedores AS T1

  LEFT JOIN silver_olist.vendedor AS T2
  ON T1.idVendedor = T2.idVendedor

  QUALIFY RN <= 10

  ORDER BY descUF, qtVendas DESC
)

SELECT * FROM tb_row_number

-- COMMAND ----------

SELECT *

FROM A

WHERE -- FILTRA NA FONTE

QUALIFY -- FILTRA WINDOW FUNCTION

HAVING -- FILTRA GROUP BY

-- COMMAND ----------

-- DBTITLE 1,#Window_functions

