-- S5__seed_orders.sql
-- Popula a tabela ORDERS com dados de teste

INSERT INTO orders (user_id, total, status) VALUES
(1, 1649.97, 'COMPLETED'),
(1, 899.98, 'COMPLETED'),
(2, 449.98, 'COMPLETED'),
(2, 1299.96, 'PENDING'),
(3, 679.99, 'COMPLETED'),
(3, 249.98, 'CANCELLED'),
(4, 359.97, 'COMPLETED'),
(4, 799.99, 'COMPLETED'),
(5, 1199.97, 'COMPLETED'),
(5, 89.99, 'PENDING');
