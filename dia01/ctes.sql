-- Databricks notebook source
-- LISTA DE VENDEDORES QUE ESTÃO NO ESTADO COM MENOS CLIENTES
--SELECT
--  descUF,
--  COUNT(DISTINCT idCliente)
--FROM
--  silver_olist.cliente
--GROUP BY
--  descUF
--ORDER BY
--  COUNT(DISTINCT idCliente) ASC

SELECT idVendedor, descUF
FROM silver_olist.vendedor
WHERE descUF in (
        SELECT descUF
        FROM silver_olist.cliente
        GROUP BY descUF
        ORDER BY COUNT(DISTINCT idCliente) DESC
        LIMIT 2)

-- COMMAND ----------

WITH tb_estado AS (
         SELECT descUF
        FROM silver_olist.cliente
        GROUP BY descUF
        ORDER BY COUNT(DISTINCT idCliente) DESC
        LIMIT 2

)

SELECT * FROM tb_estado

-- COMMAND ----------

WITH tb_estado AS (
         SELECT descUF
        FROM silver_olist.cliente
        GROUP BY descUF
        ORDER BY COUNT(DISTINCT idCliente) DESC
        LIMIT 2

)

SELECT idVendedor, 
        descUF
FROM silver_olist.vendedor
WHERE descUF in (SELECT descUF FROM tb_estado)

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
