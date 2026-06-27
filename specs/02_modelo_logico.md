# Modelo Lógico - Sistema de E-commerce
[Diagrama Lógico](../modelos/modelologico.png)
## 1. Estrutura das Tabelas

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        MODELO LÓGICO (Tabelas)                          │
└─────────────────────────────────────────────────────────────────────────┘

USERS
├─ PK: id
├─ name: VARCHAR(255)
├─ email: VARCHAR(255) (UNIQUE)
├─ password: VARCHAR(255)
├─ role_type: ENUM user_role (CUSTOMER, ADMIN)
├─ phone: VARCHAR(20)
├─ address: TEXT
├─ created_at: TIMESTAMP
└─ updated_at: TIMESTAMP

CATEGORIES
├─ PK: id
├─ name: VARCHAR (UNIQUE)
├─ description: TEXT
├─ created_at: TIMESTAMP
└─ updated_at: TIMESTAMP

PRODUCTS
├─ PK: id
├─ FK: category_id → CATEGORIES
├─ name: VARCHAR
├─ description: TEXT
├─ price: DECIMAL (> 0)
├─ created_at: TIMESTAMP
└─ updated_at: TIMESTAMP

STOCK
├─ PK: id
├─ FK: product_id → PRODUCTS (UNIQUE - 1:1)
├─ quantity: INTEGER (>= 0)
├─ created_at: TIMESTAMP
└─ updated_at: TIMESTAMP

ORDERS
├─ PK: id
├─ FK: user_id → USERS
├─ total: DECIMAL(12,2) (>= 0)
├─ status: ENUM order_status (PENDING, COMPLETED, CANCELLED)
├─ created_at: TIMESTAMP
└─ updated_at: TIMESTAMP

ORDER_ITEMS
├─ PK: id
├─ FK: order_id → ORDERS
├─ FK: product_id → PRODUCTS
├─ quantity: INTEGER (> 0)
├─ unit_price: DECIMAL (> 0)
└─ created_at: TIMESTAMP

REVIEWS
├─ PK: id
├─ FK: product_id → PRODUCTS
├─ FK: user_id → USERS
├─ UK: (product_id, user_id)
├─ rating: SMALLINT (1-5)
├─ comment: TEXT
├─ created_at: TIMESTAMP
└─ updated_at: TIMESTAMP
```

---

## 2. Descrição das Tabelas

### USERS
Armazena informações dos usuários do sistema.

**Chave Primária**: id  
**Índices**: email, role_type  
**Constraints**: email UNIQUE, role_type NOT NULL  

| Campo | Tipo | Descrição |
|-------|------|-----------|
| id | BIGSERIAL | Identificador único |
| name | VARCHAR(255) | Nome do usuário |
| email | VARCHAR(255) | Email único do usuário |
| password | VARCHAR(255) | Senha criptografada |
| role_type | user_role ENUM | Especialização: CUSTOMER ou ADMIN |
| phone | VARCHAR(20) | Telefone do usuário |
| address | TEXT | Endereço do usuário |
| created_at | TIMESTAMP | Data de criação |
| updated_at | TIMESTAMP | Última atualização |

---

### CATEGORIES
Armazena categorias de produtos.

**Chave Primária**: id  
**Índices**: name  
**Constraints**: name UNIQUE  
**Relacionamentos**: 1:N com PRODUCTS

| Campo | Tipo | Descrição |
|-------|------|-----------|
| id | BIGSERIAL | Identificador único |
| name | VARCHAR(255) | Nome da categoria |
| description | TEXT | Descrição da categoria |
| created_at | TIMESTAMP | Data de criação |
| updated_at | TIMESTAMP | Última atualização |

---

### PRODUCTS
Armazena produtos disponíveis no e-commerce.

**Chave Primária**: id  
**Chave Estrangeira**: category_id → CATEGORIES (RESTRICT DELETE)  
**Índices**: category_id, name  
**Constraints**: price > 0  
**Relacionamentos**: 1:N com CATEGORIES, 1:1 com STOCK, 1:N com ORDER_ITEMS, N:N com REVIEWS

| Campo | Tipo | Descrição |
|-------|------|-----------|
| id | BIGSERIAL | Identificador único |
| category_id | BIGINT | Referência à categoria |
| name | VARCHAR(255) | Nome do produto |
| description | TEXT | Descrição do produto |
| price | DECIMAL(10,2) | Preço unitário |
| created_at | TIMESTAMP | Data de criação |
| updated_at | TIMESTAMP | Última atualização |

---

### STOCK
Armazena informações de estoque dos produtos.

**Chave Primária**: id  
**Chave Estrangeira**: product_id → PRODUCTS (UNIQUE, CASCADE DELETE)  
**Índices**: product_id  
**Constraints**: quantity >= 0  
**Relacionamentos**: 1:1 com PRODUCTS

| Campo | Tipo | Descrição |
|-------|------|-----------|
| id | BIGSERIAL | Identificador único |
| product_id | BIGINT | Referência ao produto (UNIQUE) |
| quantity | INTEGER | Quantidade em estoque |
| created_at | TIMESTAMP | Data de criação |
| updated_at | TIMESTAMP | Última atualização |

---

### ORDERS
Armazena pedidos dos usuários.

**Chave Primária**: id  
**Chave Estrangeira**: user_id → USERS (CASCADE DELETE)  
**Índices**: user_id, status  
**Constraints**: total >= 0  
**Relacionamentos**: 1:N com USERS, 1:N com ORDER_ITEMS

| Campo | Tipo | Descrição |
|-------|------|-----------|
| id | BIGSERIAL | Identificador único |
| user_id | BIGINT | Referência ao usuário |
| total | DECIMAL(12,2) | Valor total do pedido |
| status | ENUM | Status: PENDING, COMPLETED, CANCELLED |
| created_at | TIMESTAMP | Data de criação |
| updated_at | TIMESTAMP | Última atualização |

---

### ORDER_ITEMS
Armazena itens de pedidos (relacionamento entre ORDERS e PRODUCTS).

**Chave Primária**: id  
**Chaves Estrangeiras**: 
- order_id → ORDERS (CASCADE DELETE)
- product_id → PRODUCTS (RESTRICT DELETE)

**Índices**: order_id, product_id  
**Constraints**: quantity > 0, unit_price > 0  
**Relacionamentos**: 1:N com ORDERS, 1:N com PRODUCTS

| Campo | Tipo | Descrição |
|-------|------|-----------|
| id | BIGSERIAL | Identificador único |
| order_id | BIGINT | Referência ao pedido |
| product_id | BIGINT | Referência ao produto |
| quantity | INTEGER | Quantidade do item |
| unit_price | DECIMAL(10,2) | Preço unitário no momento |
| created_at | TIMESTAMP | Data de criação |

---

### REVIEWS
Armazena avaliações de produtos (relacionamento N:N entre PRODUCTS e USERS).

**Chave Primária**: id  
**Chaves Estrangeiras**:
- product_id → PRODUCTS (CASCADE DELETE)
- user_id → USERS (CASCADE DELETE)

**Chave Única**: (product_id, user_id)  
**Índices**: product_id, user_id  
**Constraints**: rating entre 1 e 5  
**Relacionamentos**: N:N com PRODUCTS, N:N com USERS

| Campo | Tipo | Descrição |
|-------|------|-----------|
| id | BIGSERIAL | Identificador único |
| product_id | BIGINT | Referência ao produto |
| user_id | BIGINT | Referência ao usuário |
| rating | SMALLINT | Nota de 1 a 5 |
| comment | TEXT | Comentário da avaliação |
| created_at | TIMESTAMP | Data de criação |
| updated_at | TIMESTAMP | Última atualização |

---

## 3. Relacionamentos Lógicos

| Tabela 1 | Tabela 2 | Tipo | Constraint | Descrição |
|----------|----------|------|-----------|-----------|
| USERS | ORDERS | 1:N | CASCADE DELETE | Um usuário pode fazer vários pedidos |
| CATEGORIES | PRODUCTS | 1:N | RESTRICT DELETE | Uma categoria tem vários produtos |
| PRODUCTS | STOCK | 1:1 | CASCADE DELETE | Um produto tem um registro de estoque |
| ORDERS | ORDER_ITEMS | 1:N | CASCADE DELETE | Um pedido contém vários itens |
| PRODUCTS | ORDER_ITEMS | 1:N | RESTRICT DELETE | Um produto pode estar em vários pedidos |
| PRODUCTS | REVIEWS | N:N | CASCADE DELETE | Um produto recebe várias avaliações |
| USERS | REVIEWS | N:N | CASCADE DELETE | Um usuário pode avaliar vários produtos |
