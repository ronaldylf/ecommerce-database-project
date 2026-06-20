-- S7__seed_reviews.sql
-- Popula a tabela REVIEWS com dados de teste

INSERT INTO reviews (product_id, user_id, rating, comment) VALUES
-- Mouse Gamer RGB
(1, 1, 5, 'Excelente qualidade! O RGB é muito bonito e responsivo.'),
(1, 4, 4, 'Bom mouse, preço justo. Recomendo!'),

-- Teclado Mecânico
(2, 3, 5, 'Switches Cherry MX originais. Perfeito para digitação!'),
(2, 2, 4, 'Muito bom, mas um pouco barulhento.'),

-- Monitor 24 polegadas
(3, 2, 5, 'Imagem cristalina, ótimo para jogos com 144Hz.'),
(3, 5, 4, 'Bom monitor, cores vibrantes.'),

-- Fone Bluetooth
(4, 1, 5, 'Cancelamento de ruído excelente! Muito confortável.'),
(4, 3, 4, 'Boa qualidade de som, bateria dura bastante.'),

-- Carregador Rápido
(5, 1, 4, 'Carrega muito rápido, compacto e seguro.'),
(5, 2, 5, 'Melhor carregador que já tive. Muito confiável!'),

-- Clean Code
(6, 3, 5, 'Livro essencial para todo desenvolvedor. Mudou minha forma de programar.'),
(6, 4, 5, 'Excelente referência sobre qualidade de código.'),

-- O Senhor dos Anéis
(7, 1, 5, 'Obra-prima da ficção! Aproveitem a leitura.'),
(7, 5, 4, 'Ótima história, um pouco longo mas vale a pena.'),

-- Python para Análise de Dados
(8, 2, 5, 'Prático e direto ao ponto. Ótimo para aprender.'),

-- O Poder do Hábito
(9, 4, 5, 'Transformou minha vida! Recomendo muito.'),

-- Camiseta Básica Preta
(10, 1, 4, 'Ótima qualidade, algodão macio. Ficou ótima!'),
(10, 5, 5, 'Excelente preço, muito durável.'),

-- Calça Jeans Premium
(11, 2, 5, 'Muito confortável! O stretch é perfeito.'),

-- Jaqueta de Inverno
(12, 3, 4, 'Ótima proteção contra chuva, forro térmico funciona bem.'),

-- Boné Ajustável
(13, 4, 4, 'Legal, ajuste perfeito, boa qualidade.'),

-- Café Premium 500g
(14, 5, 5, 'Café de verdade! Aromático e saboroso. Voltarei a comprar!'),

-- Chocolate Belga
(15, 1, 5, 'Chocolate de primeira qualidade. Simplesmente delicioso!'),

-- Luminária de Parede
(17, 2, 5, 'Moderna e funcional. Ilumina bem o ambiente!'),

-- Cortina Blackout
(18, 3, 5, 'Bloqueia 100% da luz mesmo! Dorme muito melhor com ela.');
