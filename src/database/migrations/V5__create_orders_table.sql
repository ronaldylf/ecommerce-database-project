-- V5__create_orders_table.sql
-- Tabela de pedidos (relacionamento 1:N com users)

CREATE TYPE order_status AS ENUM ('PENDING', 'COMPLETED', 'CANCELLED');

CREATE TABLE orders (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    total DECIMAL(12, 2) NOT NULL DEFAULT 0.00 CHECK (total >= 0),
    status order_status NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_orders_user_id FOREIGN KEY (user_id)
        REFERENCES users(id) ON DELETE CASCADE
);

CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
