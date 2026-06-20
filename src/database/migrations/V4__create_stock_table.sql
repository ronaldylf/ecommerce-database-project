-- V4__create_stock_table.sql
-- Tabela de controle de estoque

CREATE TABLE stock (
    id BIGSERIAL PRIMARY KEY,
    product_id BIGINT UNIQUE NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 0 CHECK (quantity >= 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_stock_product_id FOREIGN KEY (product_id)
        REFERENCES products(id) ON DELETE CASCADE
);

CREATE INDEX idx_stock_product_id ON stock(product_id);
