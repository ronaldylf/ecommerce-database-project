-- Q3__funcao_calculate_discount.sql
-- Demonstração da Função Customizada: calculate_discount()
-- Calcula desconto por quantidade comprada
-- 5+ itens: 5% | 10+ itens: 10% | 20+ itens: 15%

SELECT
    p.id,
    p.name,
    s.quantity,
    (s.quantity * p.price)::DECIMAL(10,2) AS preco_estimado,
    calculate_discount(s.quantity, p.price)::DECIMAL(10,2) AS preco_com_desconto,
    ((s.quantity * p.price) - calculate_discount(s.quantity, p.price))::DECIMAL(10,2) AS valor_desconto,
    CASE
        WHEN s.quantity >= 20 THEN '15% - Atacado Grande'
        WHEN s.quantity >= 10 THEN '10% - Atacado'
        WHEN s.quantity >= 5 THEN '5% - Quantidade'
        ELSE 'Sem desconto'
    END AS desconto_aplicado
FROM products p
LEFT JOIN stock s ON p.id = s.product_id
WHERE s.quantity > 0
ORDER BY s.quantity DESC;
