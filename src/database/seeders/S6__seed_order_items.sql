-- S6__seed_order_items.sql
-- Popula a tabela ORDER_ITEMS com dados de teste
-- Nota: As triggers vão automaticamente decrementar o estoque

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
-- Pedido 1: João Silva
(1, 1, 5, 149.99),
(1, 4, 2, 299.99),

-- Pedido 2: João Silva
(2, 7, 6, 79.90),

-- Pedido 3: Maria Santos
(3, 10, 3, 29.99),
(3, 11, 2, 129.99),

-- Pedido 4: Maria Santos
(4, 3, 1, 799.99),
(4, 5, 10, 89.99),

-- Pedido 5: Carlos Oliveira
(5, 2, 1, 349.99),
(5, 6, 1, 89.90),

-- Pedido 6: Carlos Oliveira (CANCELADO)
(6, 8, 2, 109.90),

-- Pedido 7: Ana Costa
(7, 9, 2, 59.90),
(7, 15, 3, 24.99),

-- Pedido 8: Ana Costa
(8, 12, 1, 39.99),
(8, 17, 2, 79.99),

-- Pedido 9: Pedro Ferreira
(9, 14, 1, 34.99),
(9, 16, 2, 129.99),
(9, 18, 3, 89.99),

-- Pedido 10: Pedro Ferreira
(10, 13, 1, 19.99);
