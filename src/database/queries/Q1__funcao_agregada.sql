-- Q1__funcao_agregada.sql
-- Consulta com Função Agregada (COUNT, SUM, AVG)
-- Retorna o total de vendas por categoria

SELECT
    c.id,
    c.name AS categoria,
    COUNT(DISTINCT o.id) AS total_pedidos,
    SUM(oi.quantity) AS total_itens_vendidos,
    SUM(oi.quantity * oi.unit_price)::DECIMAL(10,2) AS receita_total,
    AVG(oi.unit_price)::DECIMAL(10,2) AS preco_medio_item,
    COUNT(p.id) AS total_produtos
FROM categories c
LEFT JOIN products p ON c.id = p.category_id
LEFT JOIN order_items oi ON p.id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.id AND o.status = 'COMPLETED'
GROUP BY c.id, c.name
ORDER BY receita_total DESC NULLS LAST;
