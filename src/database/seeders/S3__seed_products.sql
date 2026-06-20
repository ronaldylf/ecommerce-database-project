-- S3__seed_products.sql
-- Popula a tabela PRODUCTS com dados de teste

INSERT INTO products (category_id, name, description, price) VALUES
-- Eletrônicos
(1, 'Mouse Gamer RGB', 'Mouse com 7 botões programáveis e LED RGB ajustável', 149.99),
(1, 'Teclado Mecânico', 'Teclado mecânico com switches Cherry MX e iluminação RGB', 349.99),
(1, 'Monitor 24 polegadas', 'Monitor FHD 24" com taxa de atualização 144Hz', 799.99),
(1, 'Fone Bluetooth', 'Fone over-ear com cancelamento de ruído ativo', 299.99),
(1, 'Carregador Rápido', 'Carregador USB-C com suporte a carregamento rápido 65W', 89.99),

-- Livros
(2, 'Clean Code', 'Livro sobre como escrever código limpo e mantível', 89.90),
(2, 'O Senhor dos Anéis', 'Clássico da ficção científica de J.R.R. Tolkien', 79.90),
(2, 'Python para Análise de Dados', 'Guia prático sobre análise de dados com Python', 109.90),
(2, 'O Poder do Hábito', 'Livro sobre formação e mudança de hábitos', 59.90),

-- Roupas
(3, 'Camiseta Básica Preta', 'Camiseta de algodão 100%, cor preta, unissex', 29.99),
(3, 'Calça Jeans Premium', 'Calça jeans com stretch, durável e confortável', 129.99),
(3, 'Jaqueta de Inverno', 'Jaqueta impermeável com forro térmico', 249.99),
(3, 'Boné Ajustável', 'Boné em algodão com fechamento ajustável', 39.99),

-- Alimentos
(4, 'Café Premium 500g', 'Café coado de grão selecionado, torrado na hora', 34.99),
(4, 'Chocolate Belga 100g', 'Chocolate ao leite importado da Bélgica', 24.99),
(4, 'Granola Integral', 'Granola caseira com frutas secas e mel', 19.99),

-- Casa e Jardim
(5, 'Luminária de Parede', 'Luminária moderna em alumínio com lâmpada LED', 79.99),
(5, 'Cortina Blackout', 'Cortina impermeável que bloqueia 100% da luz', 129.99),
(5, 'Escada Dobrável', 'Escada de alumínio dobrável, 3 degraus', 89.99);
