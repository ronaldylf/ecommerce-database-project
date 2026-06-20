-- V1__create_users_table.sql
-- Tabela de usuários com especialização via role_type

CREATE TYPE user_role AS ENUM ('CUSTOMER', 'ADMIN');

CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role_type user_role NOT NULL DEFAULT 'CUSTOMER',
    phone VARCHAR(20),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role_type ON users(role_type);
