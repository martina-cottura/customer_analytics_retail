USE customer_analytics

-- Consulta 1: I ¿ cuál es la distribución por clientes por segmento RFM? 
-- Objetivo: identificar la proporción de clientes en cada segmento para orientar estrategias de marketing y fidelización
SELECT 
    segmento_rfm,
    COUNT(*) AS total_clientes,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS porcentaje
FROM clientes_rfm
GROUP BY segmento_rfm
ORDER BY porcentaje DESC;

-- Consulta 2.1 : Porcentaje de clientes en riesgo churn
SELECT 
    COUNT(*) AS total_clientes,
    SUM(churn_riesgo) AS clientes_en_riesgo,
    ROUND(100.0 * SUM(churn_riesgo) / COUNT(*), 2) AS porcentaje_churn
FROM clientes_rfm;


-- Consulta 2.2: Riesgo de churn por segmento RFM 
SELECT 
    segmento_rfm,
    COUNT(*) AS total_clientes,
    SUM(churn_riesgo) AS clientes_en_riesgo,
    ROUND(100.0 * SUM(churn_riesgo) / COUNT(*), 2) AS tasa_churn
FROM clientes_rfm
GROUP BY segmento_rfm
ORDER BY tasa_churn DESC, total_clientes DESC;

-- Consulta 2.3: Validación del umbral de 237 días

SELECT 
    MIN(recencia) AS recencia_min,
    MAX(recencia) AS recencia_max,
    ROUND(AVG(recencia), 2) AS recencia_promedio,
    SUM(CASE WHEN recencia > 237 THEN 1 ELSE 0 END) AS clientes_en_riesgo,
    ROUND(100.0 * SUM(CASE WHEN recencia > 237 THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_riesgo
FROM clientes_rfm
WHERE recencia <> 999;

-- Consulta 3: LTV medio por segmento RFM 
SELECT 
    c.segmento_rfm,
    COUNT(DISTINCT c.customer_id) AS total_clientes,
    ROUND(SUM(t.importe), 2) AS ingreso_total,
    ROUND(SUM(t.importe) / COUNT(DISTINCT c.customer_id), 2) AS ltv_real
FROM clientes_rfm c
JOIN transacciones t 
    ON c.customer_id = t.customer_id
GROUP BY c.segmento_rfm
ORDER BY ltv_real DESC;

-- Consulta 4: Canal de venta según ticket medio e ingresos totales según tienda física y web 

SELECT 
    ti.store_id,
    ti.nombre,
    COUNT(t.transaction_id) AS total_transacciones,
    ROUND(AVG(t.importe), 2) AS ticket_promedio,
    ROUND(SUM(t.importe), 2) AS ingresos_totales
FROM transacciones t
JOIN tiendas ti 
    ON t.store_id = ti.store_id
GROUP BY ti.store_id, ti.nombre
ORDER BY ticket_promedio DESC;

-- Consulta 5: Categoría con mayor valor por transacción 

SELECT 
    p.categoria,
    COUNT(t.transaction_id) AS total_transacciones,
    ROUND(AVG(t.importe), 2) AS valor_promedio_transaccion,
    ROUND(SUM(t.importe), 2) AS ingresos_totales
FROM transacciones t
JOIN productos p 
    ON t.product_id = p.product_id
GROUP BY p.categoria
ORDER BY valor_promedio_transaccion DESC;

-- Consulta 6: Evolución de la actividad de compra en el tiempo 

SELECT 
    DATE_FORMAT(fecha, '%Y-%m') AS periodo,
    COUNT(*) AS total_transacciones,
    ROUND(SUM(importe), 2) AS ingresos_totales,
    ROUND(AVG(importe), 2) AS ticket_promedio
FROM transacciones
GROUP BY periodo
ORDER BY periodo;


