# Modelo Físico - Sistema de E-commerce (PostgreSQL)
[Diagrama Físico](../modelos/modelofisico.png)
## 1. Tipos de Dados

| Tipo Lógico | Tipo Físico PostgreSQL | Uso |
|------------|------------------------|-----|
| Identificador | BIGSERIAL | Chaves primárias auto-incrementáveis |
| Texto Curto | VARCHAR(n) | Nomes, emails, telefones |
| Texto Longo | TEXT | Descrições, comentários |
| Número Inteiro | INTEGER | Quantidades, contadores |
| Número Decimal | DECIMAL(p,s) | Preços, totais |
| Data/Hora | TIMESTAMP | Datas de criação/atualização |
| Booleano | BOOLEAN | Valores verdadeiro/falso |
| Enumeração | ENUM | Valores pré-definidos (role_type, status) |
| Array | TEXT[] | Múltiplos valores |

---

## 2. Constraints e Validações

### Chaves Primárias
Todas as tabelas possuem uma coluna `id` como chave primária BIGSERIAL.

### Chaves Únicas
- `users.email` - Email único por usuário
- `categories.name` - Nome único por categoria
- `stock.product_id` - Um produto tem apenas um registro de estoque
- `reviews(product_id, user_id)` - Um usuário avalia cada produto apenas uma vez

### Chaves Estrangeiras

| Tabela | Coluna | Referência | Ação |
|--------|--------|-----------|------|
| products | category_id | categories.id | RESTRICT DELETE |
| stock | product_id | products.id | CASCADE DELETE |
| orders | user_id | users.id | CASCADE DELETE |
| order_items | order_id | orders.id | CASCADE DELETE |
| order_items | product_id | products.id | RESTRICT DELETE |
| reviews | product_id | products.id | CASCADE DELETE |
| reviews | user_id | users.id | CASCADE DELETE |

### Constraints de Check

- `products.price > 0` - Preço deve ser positivo
- `stock.quantity >= 0` - Quantidade não pode ser negativa
- `orders.total >= 0` - Total não pode ser negativo
- `order_items.quantity > 0` - Quantidade deve ser maior que zero
- `order_items.unit_price > 0` - Preço unitário deve ser positivo
- `reviews.rating >= 1 AND rating <= 5` - Rating entre 1 e 5

---

## 3. Índices

### Índices de Busca Rápida

```sql
-- USERS
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role_type ON users(role_type);

-- CATEGORIES
CREATE INDEX idx_categories_name ON categories(name);

-- PRODUCTS
CREATE INDEX idx_products_category_id ON products(category_id);
CREATE INDEX idx_products_name ON products(name);

-- STOCK
CREATE INDEX idx_stock_product_id ON stock(product_id);

-- ORDERS
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);

-- ORDER_ITEMS
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);

-- REVIEWS
CREATE INDEX idx_reviews_product_id ON reviews(product_id);
CREATE INDEX idx_reviews_user_id ON reviews(user_id);
```

---

## 4. Tipos Enumerados (ENUM)

### user_role
```sql
CREATE TYPE user_role AS ENUM ('CUSTOMER', 'ADMIN');
```
Define os tipos de usuários no sistema.

### order_status
```sql
CREATE TYPE order_status AS ENUM ('PENDING', 'COMPLETED', 'CANCELLED');
```
Define os possíveis estados de um pedido.

---

## 5. Funções Customizadas

### calculate_discount(quantity INTEGER, unit_price DECIMAL)
Calcula o preço com desconto baseado na quantidade comprada.

**Lógica de Desconto:**
- 5 ou mais itens: 5% de desconto
- 10 ou mais itens: 10% de desconto
- 20 ou mais itens: 15% de desconto

**Retorno**: DECIMAL com o preço total após desconto

```sql
-- Exemplo de uso
SELECT calculate_discount(10, 100.00);  -- Retorna 900.00 (10% desconto)
SELECT calculate_discount(25, 100.00);  -- Retorna 2125.00 (15% desconto em 2500)
```

---

## 6. Triggers

### Trigger 1: decrease_stock_on_order_item_insert()
**Evento**: AFTER INSERT ON order_items

**Ação**: Decrementa automaticamente a quantidade em estoque quando um item é adicionado a um pedido.

**Campos Afetados**:
- `stock.quantity` - diminui
- `stock.updated_at` - atualizado

**Validações**:
- Verifica se o estoque existe para o produto
- Valida se a quantidade não fica negativa

### Trigger 2: increase_stock_on_order_item_delete()
**Evento**: AFTER DELETE ON order_items

**Ação**: Incrementa automaticamente a quantidade em estoque quando um item é removido de um pedido.

**Campos Afetados**:
- `stock.quantity` - aumenta
- `stock.updated_at` - atualizado

### Trigger 3: update_timestamp()
**Evento**: BEFORE UPDATE em todas as tabelas

**Ação**: Atualiza automaticamente o campo `updated_at` para CURRENT_TIMESTAMP.

**Tabelas Afetadas**:
- users
- categories
- products
- stock
- orders
- reviews

---

## 7. Integridade Referencial

### CASCADE DELETE
Quando um registro é deletado, todos os registros dependentes também são deletados.

- Deletar um **order**: deleta todos seus **order_items**
- Deletar um **product**: deleta seu **stock** e suas **reviews**
- Deletar um **user**: deleta todos seus **orders** e **reviews**

### RESTRICT DELETE
Impede a deleção se existem registros dependentes.

- **categories** não pode ser deletada se tem **products**
- **products** não pode ser deletado se tem **order_items**

### SET NULL
Quando um registro é deletado, a chave estrangeira é setada como NULL.

Não é utilizado neste modelo (mantemos integridade total).

---

## 8. Otimizações de Performance

### Índices Compostos (Possíveis Melhorias Futuras)
```sql
CREATE INDEX idx_reviews_product_rating ON reviews(product_id, rating DESC);
CREATE INDEX idx_orders_user_status ON orders(user_id, status);
CREATE INDEX idx_order_items_order_product ON order_items(order_id, product_id);
```

### Particionamento (Possível para Grandes Volumes)
```sql
-- Particionar tabela orders por data (future improvement)
CREATE TABLE orders_2024_q1 PARTITION OF orders
    FOR VALUES FROM ('2024-01-01') TO ('2024-04-01');
```

---

## 9. Resumo Físico

| Aspecto | Detalhes |
|--------|----------|
| **SGBD** | PostgreSQL 15 |
| **Tabelas** | 7 (USERS, CATEGORIES, PRODUCTS, STOCK, ORDERS, ORDER_ITEMS, REVIEWS) |
| **Índices** | 11+ índices de busca rápida |
| **Enums** | 2 (user_role, order_status) |
| **Funções** | 1 (calculate_discount) |
| **Triggers** | 6 triggers automáticas |
| **Constraints** | Chaves primárias, únicas, estrangeiras e checks |
| **Volume de Dados** | Suporta milhões de registros com performance |
| **Armazenamento** | Padrão PostgreSQL (versioning, MVCC) |

---

## 10. Implementação em SQL

A implementação física deste modelo foi separada em **8 migrations SQL** individuais (padrão Flyway) para facilitar a visualização e manutenção:

- **V1__create_users_table.sql** - Criação da tabela USERS
- **V2__create_categories_table.sql** - Criação da tabela CATEGORIES
- **V3__create_products_table.sql** - Criação da tabela PRODUCTS
- **V4__create_stock_table.sql** - Criação da tabela STOCK
- **V5__create_orders_table.sql** - Criação da tabela ORDERS
- **V6__create_order_items_table.sql** - Criação da tabela ORDER_ITEMS
- **V7__create_reviews_table.sql** - Criação da tabela REVIEWS
- **V8__create_functions_and_triggers.sql** - Criação de funções e triggers

Todas as migrations estão localizadas em `src/database/migrations/` e são **executadas automaticamente** ao iniciar o Docker.
