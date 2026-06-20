-- Q5__consultas_adicionais.sql
-- Consultas adicionais para análise de dados

-- ============================================================================
-- 1. Top 5 Usuários que Mais Fizeram Pedidos
-- ============================================================================
SELECT
    u.id,
    u.name,
    u.email,
    COUNT(o.id) AS total_pedidos,
    SUM(o.total)::DECIMAL(10,2) AS gasto_total
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
WHERE o.status = 'COMPLETED'
GROUP BY u.id, u.name, u.email
ORDER BY total_pedidos DESC
LIMIT 5;


-- ============================================================================
-- 2. Produtos com Melhor Avaliação Média
-- ============================================================================
SELECT
    p.id,
    p.name,
    c.name AS categoria,
    AVG(r.rating)::NUMERIC(3,2) AS rating_medio,
    COUNT(r.id) AS total_avaliacoes,
    p.price
FROM products p
LEFT JOIN categories c ON p.category_id = c.id
LEFT JOIN reviews r ON p.id = r.product_id
GROUP BY p.id, p.name, c.name, p.price
HAVING COUNT(r.id) > 0
ORDER BY rating_medio DESC;


-- ============================================================================
-- 3. Produtos com Baixo Estoque (Menos de 20 Unidades)
-- ============================================================================
SELECT
    p.id,
    p.name,
    p.price,
    s.quantity,
    CASE
        WHEN s.quantity = 0 THEN 'CRÍTICO'
        WHEN s.quantity < 5 THEN 'MUITO BAIXO'
        WHEN s.quantity < 10 THEN 'BAIXO'
        ELSE 'OK'
    END AS status_estoque
FROM products p
JOIN stock s ON p.id = s.product_id
WHERE s.quantity < 20
ORDER BY s.quantity ASC;


-- ============================================================================
-- 4. Detalhamento de Vendas por Produto
-- ============================================================================
SELECT
    p.id,
    p.name,
    c.name AS categoria,
    COUNT(DISTINCT oi.order_id) AS vezes_comprado,
    SUM(oi.quantity) AS total_unidades_vendidas,
    SUM(oi.quantity * oi.unit_price)::DECIMAL(10,2) AS receita_produto,
    AVG(oi.unit_price)::DECIMAL(10,2) AS preco_medio_venda,
    s.quantity AS estoque_atual
FROM products p
LEFT JOIN categories c ON p.category_id = c.id
LEFT JOIN order_items oi ON p.id = oi.product_id
LEFT JOIN stock s ON p.id = s.product_id
GROUP BY p.id, p.name, c.name, s.quantity
ORDER BY receita_produto DESC NULLS LAST;


-- ============================================================================
-- 5. Resumo Geral do E-commerce
-- ============================================================================
SELECT
    (SELECT COUNT(DISTINCT id) FROM users WHERE role_type = 'CUSTOMER') AS total_clientes,
    (SELECT COUNT(DISTINCT id) FROM orders WHERE status = 'COMPLETED') AS pedidos_completos,
    (SELECT COUNT(*) FROM products) AS total_produtos,
    (SELECT SUM(quantity) FROM stock) AS itens_em_estoque,
    (SELECT SUM(total)::DECIMAL(10,2) FROM orders WHERE status = 'COMPLETED') AS receita_total,
    (SELECT AVG(total)::DECIMAL(10,2) FROM orders WHERE status = 'COMPLETED') AS ticket_medio;
