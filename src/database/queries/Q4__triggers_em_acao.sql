-- Q4__triggers_em_acao.sql
-- Demonstração das Triggers em Ação
-- 1. Controle automático de estoque ao adicionar itens
-- 2. Atualização automática do campo updated_at

-- ============================================================================
-- A. Trigger de Estoque
-- ============================================================================
-- Mostra como o estoque é automaticamente decrementado quando um item
-- é adicionado a um pedido (via trigger decrease_stock_on_order_item_insert)

SELECT
    p.id,
    p.name,
    s.quantity AS estoque_atual,
    (SELECT SUM(oi.quantity) FROM order_items oi WHERE oi.product_id = p.id) AS total_vendido,
    s.updated_at AS ultima_atualizacao_estoque
FROM products p
LEFT JOIN stock s ON p.id = s.product_id
ORDER BY s.quantity ASC;


-- ============================================================================
-- B. Trigger de Timestamp
-- ============================================================================
-- Mostra como updated_at é atualizado automaticamente (via trigger update_timestamp)
-- quando qualquer registro é modificado

SELECT
    id,
    name,
    email,
    created_at,
    updated_at,
    CASE
        WHEN updated_at > created_at THEN 'Sim - Atualizado'
        ELSE 'Não - Recém criado'
    END AS foi_modificado,
    EXTRACT(EPOCH FROM (updated_at - created_at)) AS segundos_desde_criacao
FROM users
ORDER BY updated_at DESC;
