-- Q2__having.sql
-- Consulta com HAVING
-- Retorna categorias que tiveram mais de 5 itens vendidos e receita > 500

SELECT
    c.id,
    c.name AS categoria,
    COUNT(p.id) AS total_produtos,
    SUM(oi.quantity) AS quantidade_vendida,
    SUM(oi.quantity * oi.unit_price)::DECIMAL(10,2) AS receita_total
FROM categories c
LEFT JOIN products p ON c.id = p.category_id
LEFT JOIN order_items oi ON p.id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.id AND o.status = 'COMPLETED'
GROUP BY c.id, c.name
HAVING SUM(oi.quantity) > 5 AND SUM(oi.quantity * oi.unit_price) > 500.00
ORDER BY receita_total DESC;
