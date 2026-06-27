# Modelo Conceitual - Sistema de E-commerce
[Diagrama Conceitual](../modelos/modeloconceitual.png)
## 1. Definição do Problema

Um sistema de gerenciamento de e-commerce que permite:
- **Cadastro de produtos** com categorias e controle de estoque
- **Gestão de pedidos** com histórico de compras
- **Sistema de avaliações** de produtos por clientes
- **Controle de usuários** diferenciando clientes e administradores
- **Rastreamento de estoque** com atualização automática

---

## 2. Diagrama Conceitual (Notação ER)

```
┌─────────────────────────────────────────────────────────────────────────┐
│                          MODELO CONCEITUAL                              │
└─────────────────────────────────────────────────────────────────────────┘

                            ┌──────────────┐
                            │    USERS     │
                            │──────────────│
                            │ id           │
                            │ name         │
                            │ email        │
                            │ password     │
                            │ role_type*   │ ◄─── ESPECIALIZAÇÃO
                            │ phone        │      (CUSTOMER/ADMIN)
                            │ address      │
                            │ created_at   │
                            └──────────────┘
                                    │
                          ┌─────────┴─────────┐
                          │1:N                │
                          ▼                   ▼
                     ┌──────────┐      ┌──────────────┐
                     │  ORDERS  │      │  CATEGORIES  │
                     ├──────────┤      ├──────────────┤
                     │ id       │      │ id           │
                     │ user_id  │      │ name         │
                     │ total    │      │ description  │
                     │ status   │      │ created_at   │
                     └──────────┘      └──────────────┘
                          │                    │
                     ┌────┴────┐          ┌────┴───────┐
                     │1:N      │          │1:N         │
                     ▼         ▼          ▼            ▼
              ┌────────────┐  ┌──────────────┐  ┌──────────────┐
              │ORDER_ITEMS │  │   PRODUCTS   │  │   REVIEWS    │
              ├────────────┤  ├──────────────┤  ├──────────────┤
              │ id         │  │ id           │  │ id           │
              │ order_id   │  │ category_id  │  │ product_id   │
              │ product_id │  │ name         │  │ user_id      │
              │ quantity   │  │ price        │  │ rating       │
              │ unit_price │  │ 1:1          │  │ comment      │
              └────────────┘  │ STOCK        │  └──────────────┘
                     │         │ ┌──────────┤         ▲
                     └─────────┼─┤ id       │         │
                               │ │prod_id   │         │
                               │ │quantity  │         │
                               └────────────┘         │
                                     ▲                │
                                     └────────────────┘
                         PRODUCTS ↔ REVIEWS (N:N)
```

---

## 3. Descrição das Entidades

#### **USERS**
- id: identificador único
- name: nome do usuário
- email: email único
- password: senha criptografada
- **role_type**: tipo de usuário (CUSTOMER ou ADMIN) - **ESPECIALIZAÇÃO**
- phone: telefone (para customers)
- address: endereço (para customers)
- created_at: data de criação
- updated_at: última atualização

#### **CATEGORIES**
- id: identificador único
- name: nome da categoria
- description: descrição
- created_at: data de criação
- updated_at: última atualização

#### **PRODUCTS**
- id: identificador único
- category_id: referência a CATEGORIES (1:N)
- name: nome do produto
- description: descrição
- price: preço unitário (> 0)
- created_at: data de criação
- updated_at: última atualização

#### **STOCK** (Relacionamento 1:1 com PRODUCTS)
- id: identificador único
- product_id: referência única a PRODUCTS (1:1)
- quantity: quantidade em estoque (>= 0)
- created_at: data de criação
- updated_at: última atualização

#### **ORDERS**
- id: identificador único
- user_id: referência a USERS (1:N)
- total: valor total do pedido (>= 0)
- status: status do pedido (PENDING, COMPLETED, CANCELLED)
- created_at: data de criação
- updated_at: última atualização

#### **ORDER_ITEMS** (Relacionamento entre ORDERS e PRODUCTS)
- id: identificador único
- order_id: referência a ORDERS (1:N, CASCADE DELETE)
- product_id: referência a PRODUCTS (1:N, RESTRICT DELETE)
- quantity: quantidade de itens (> 0)
- unit_price: preço do produto no momento da compra (> 0)
- created_at: data de criação

#### **REVIEWS** (Relacionamento N:N)
- id: identificador único
- product_id: referência a PRODUCTS (N:N, CASCADE DELETE)
- user_id: referência a USERS (N:N, CASCADE DELETE)
- rating: nota de 1 a 5
- comment: comentário da avaliação
- created_at: data de criação
- updated_at: última atualização

---

## 4. Relacionamentos

| Origem | Destino | Tipo | Descrição |
|--------|---------|------|-----------|
| USERS | ORDERS | 1:N | Um usuário faz vários pedidos |
| CATEGORIES | PRODUCTS | 1:N | Uma categoria tem vários produtos |
| ORDERS | ORDER_ITEMS | 1:N | Um pedido contém vários itens |
| PRODUCTS | ORDER_ITEMS | 1:N | Um produto pode estar em vários pedidos |
| PRODUCTS | REVIEWS | N:N | Um produto recebe várias avaliações de múltiplos usuários |

---

## 5. Especialização

- **Entidade Pai**: USERS
- **Subtipo 1**: CUSTOMER (atributos específicos: phone, address)
- **Subtipo 2**: ADMIN (atributos herdados de USERS, role_type = 'ADMIN')
- **Tipo de Especialização**: Total (todo usuário deve ser CUSTOMER ou ADMIN via role_type)

---

## 6. Atendimento aos Requisitos

✅ **Cinco Entidades**: USERS, CATEGORIES, PRODUCTS, ORDERS, REVIEWS (7 tabelas no total)

✅ **Relacionamento 1:N**: 
- USERS → ORDERS
- CATEGORIES → PRODUCTS
- ORDERS → ORDER_ITEMS
- PRODUCTS → ORDER_ITEMS

✅ **Relacionamento N:N**: 
- PRODUCTS ↔ REVIEWS

✅ **Especialização**: 
- USERS com role_type (CUSTOMER ou ADMIN)
