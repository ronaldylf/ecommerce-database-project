-- V8__create_functions_and_triggers.sql
-- Função customizada e triggers automáticas

-- ============================================================================
-- FUNÇÃO 1: Calcular desconto baseado em quantidade
-- ============================================================================
CREATE OR REPLACE FUNCTION calculate_discount(quantity INTEGER, unit_price DECIMAL)
RETURNS DECIMAL AS $$
DECLARE
    discount_percent DECIMAL;
    total_price DECIMAL;
BEGIN
    total_price := quantity * unit_price;

    CASE
        WHEN quantity >= 20 THEN discount_percent := 0.15;
        WHEN quantity >= 10 THEN discount_percent := 0.10;
        WHEN quantity >= 5 THEN discount_percent := 0.05;
        ELSE discount_percent := 0;
    END CASE;

    RETURN total_price * (1 - discount_percent);
END;
$$ LANGUAGE plpgsql IMMUTABLE;


-- ============================================================================
-- TRIGGER 1: Decrementar estoque quando um item é adicionado ao pedido
-- ============================================================================
CREATE OR REPLACE FUNCTION decrease_stock_on_order_item_insert()
RETURNS TRIGGER AS $$
BEGIN
    -- Decrementa a quantidade em estoque
    UPDATE stock
    SET quantity = quantity - NEW.quantity,
        updated_at = CURRENT_TIMESTAMP
    WHERE product_id = NEW.product_id;

    -- Verifica se o estoque foi decrementado com sucesso
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Estoque não encontrado para o produto ID: %', NEW.product_id;
    END IF;

    -- Verifica se não ficou com quantidade negativa
    IF (SELECT quantity FROM stock WHERE product_id = NEW.product_id) < 0 THEN
        RAISE EXCEPTION 'Quantidade insuficiente em estoque para o produto ID: %', NEW.product_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_decrease_stock_on_order_item_insert
AFTER INSERT ON order_items
FOR EACH ROW
EXECUTE FUNCTION decrease_stock_on_order_item_insert();


-- ============================================================================
-- TRIGGER 2: Incrementar estoque quando um item é removido do pedido
-- ============================================================================
CREATE OR REPLACE FUNCTION increase_stock_on_order_item_delete()
RETURNS TRIGGER AS $$
BEGIN
    -- Incrementa a quantidade em estoque
    UPDATE stock
    SET quantity = quantity + OLD.quantity,
        updated_at = CURRENT_TIMESTAMP
    WHERE product_id = OLD.product_id;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_increase_stock_on_order_item_delete
AFTER DELETE ON order_items
FOR EACH ROW
EXECUTE FUNCTION increase_stock_on_order_item_delete();


-- ============================================================================
-- TRIGGER 3: Atualizar updated_at em todas as tabelas
-- ============================================================================
CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_users_timestamp
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER trg_update_categories_timestamp
BEFORE UPDATE ON categories
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER trg_update_products_timestamp
BEFORE UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER trg_update_stock_timestamp
BEFORE UPDATE ON stock
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER trg_update_orders_timestamp
BEFORE UPDATE ON orders
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER trg_update_reviews_timestamp
BEFORE UPDATE ON reviews
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();
