-- S1__seed_users.sql
-- Popula a tabela USERS com dados de teste

INSERT INTO users (name, email, password, role_type, phone, address) VALUES
('João Silva', 'joao.silva@example.com', 'senha123', 'CUSTOMER', '11999999999', 'Rua A, 123, São Paulo - SP'),
('Maria Santos', 'maria.santos@example.com', 'senha123', 'CUSTOMER', '11988888888', 'Avenida B, 456, Rio de Janeiro - RJ'),
('Carlos Oliveira', 'carlos.oliveira@example.com', 'senha123', 'CUSTOMER', '21987654321', 'Rua C, 789, Belo Horizonte - MG'),
('Ana Costa', 'ana.costa@example.com', 'senha123', 'CUSTOMER', '31986543210', 'Avenida D, 321, Salvador - BA'),
('Pedro Ferreira', 'pedro.ferreira@example.com', 'senha123', 'CUSTOMER', '85985551234', 'Rua E, 654, Fortaleza - CE'),
('Administrador', 'admin@example.com', 'admin123', 'ADMIN', '11900000000', 'Avenida Administrativa, 1000, São Paulo - SP');
