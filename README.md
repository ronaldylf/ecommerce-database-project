# Sistema de E-commerce - Banco de Dados

Trabalho de modelagem de banco de dados de um sistema de e-commerce com PostgreSQL e Docker.

## 📋 Requisitos

- Docker e Docker Compose

## 🚀 Como Executar

### 1. Iniciar o Docker

```bash
docker-compose up -d
```

Isso irá:
- Criar o container PostgreSQL (`ecommerce-db`) e executar as migrations
- Criar o container Seeder (`ecommerce-seeder`) que aguarda o PostgreSQL estar pronto e executa os seeders automaticamente
- Criar o container Adminer (`ecommerce-adminer`) - uma interface web para gerenciar o banco
- Criar um volume para persistência de dados

**Fluxo:**
1. PostgreSQL sobe → Executa migrations (V1-V8)
2. Seeder aguarda PostgreSQL estar saudável → Executa seeders (S1-S7)
3. Adminer sobe e acessa o banco já populado
4. Seeder encerra após completar

### 2. Verificar Status

```bash
docker-compose ps
```

Você deve ver os dois containers rodando (status: Up).

### 3. Parar o Docker

```bash
docker-compose down
```

Para remover todos os dados:
```bash
docker-compose down -v
```

---

## 🗄️ Acessar o Banco de Dados

### Dados de Acesso

```
URL de Conexão:  postgresql://localhost:5432/ecommerce_db
Usuário:         user
Senha:           password
Banco:           ecommerce_db
Host:            localhost
Porta:           5432
```

### Opção 1: Interface Web (Adminer)

> 💡 **Dica**: O Docker já subiu um container com Adminer (interface web para gerenciar o banco)!

1. Acesse: **http://localhost:8080**
2. Preencha os campos:
   - Sistema: `PostgreSQL`
   - Servidor: `postgres`
   - Usuário: `user`
   - Senha: `password`
   - Banco: `ecommerce_db`
3. Clique em "Login"

### Opção 2: Visualizador de Banco de Dados

Você pode usar qualquer visualizador de banco de dados (DBeaver, pgAdmin, DataGrip, etc.) conectando com os dados de acesso acima:

- **Host**: `localhost`
- **Porta**: `5432`
- **Usuário**: `user`
- **Senha**: `password`
- **Banco**: `ecommerce_db`

---

## 📊 Estrutura do Banco de Dados

### Tabelas (7 no total)

1. **USERS** - Usuários (com especialização: CUSTOMER ou ADMIN)
2. **CATEGORIES** - Categorias de produtos
3. **PRODUCTS** - Produtos
4. **STOCK** - Controle de estoque (1:1 com PRODUCTS)
5. **ORDERS** - Pedidos
6. **ORDER_ITEMS** - Itens de pedido
7. **REVIEWS** - Avaliações de produtos

### Relacionamentos

- **1:N**: USERS → ORDERS
- **1:N**: CATEGORIES → PRODUCTS
- **1:N**: ORDERS → ORDER_ITEMS
- **1:N**: PRODUCTS → ORDER_ITEMS
- **1:1**: PRODUCTS → STOCK
- **N:N**: PRODUCTS ↔ REVIEWS

### Especialização

- **USERS.role_type**: CUSTOMER ou ADMIN

---

## 🌱 Dados de Teste (Seeders)

Os arquivos de seeder em `src/database/seeders/` são executados **automaticamente** após as migrations quando você inicia o Docker (via serviço `seeder` dedicado). Eles criam dados de teste:
- 6 usuários (5 clientes + 1 admin)
- 5 categorias de produtos
- 18 produtos variados
- Estoque para cada produto
- 10 pedidos com diferentes status
- Avaliações de produtos

---

## 📝 Consultas SQL

Todas as consultas obrigatórias estão em `src/database/queries/`:

- **Q1__funcao_agregada.sql** - Função agregada (COUNT, SUM, AVG)
- **Q2__having.sql** - Consulta com HAVING (filtro pós-agregação)
- **Q3__funcao_calculate_discount.sql** - Função customizada (calculate_discount)
- **Q4__triggers_em_acao.sql** - Triggers automáticas em ação (estoque e timestamp)
- **Q5__consultas_adicionais.sql** - Exemplos adicionais de análise

---

## 📂 Estrutura do Projeto

```
ecommerce/
├── docker-compose.yaml          ← Configuração Docker
├── README.md                    ← Este arquivo
├── .env.example                 ← Exemplo de variáveis
├── .gitignore                   ← Arquivos ignorados no git
│
├── specs/                       ← Documentação dos modelos
│   ├── 01_modelo_conceitual.md  ← Diagrama e entidades
│   ├── 02_modelo_logico.md      ← Tabelas e relacionamentos
│   └── 03_modelo_fisico.md      ← SQL, tipos, constraints e migrations
│
└── src/database/
    ├── migrations/              ← 8 migrations SQL (executadas automaticamente)
    │   ├── V1__create_users_table.sql
    │   ├── V2__create_categories_table.sql
    │   ├── V3__create_products_table.sql
    │   ├── V4__create_stock_table.sql
    │   ├── V5__create_orders_table.sql
    │   ├── V6__create_order_items_table.sql
    │   ├── V7__create_reviews_table.sql
    │   └── V8__create_functions_and_triggers.sql
    │
    ├── seeders/                 ← 7 seeders SQL para dados de teste
    │   ├── S1__seed_users.sql
    │   ├── S2__seed_categories.sql
    │   ├── S3__seed_products.sql
    │   ├── S4__seed_stock.sql
    │   ├── S5__seed_orders.sql
    │   ├── S6__seed_order_items.sql
    │   └── S7__seed_reviews.sql
    │
    └── queries/                 ← 5 consultas SQL obrigatórias
        ├── Q1__funcao_agregada.sql
        ├── Q2__having.sql
        ├── Q3__funcao_calculate_discount.sql
        ├── Q4__triggers_em_acao.sql
        └── Q5__consultas_adicionais.sql
```

---

## 📚 Documentação

- **Modelo Conceitual**: `specs/01_modelo_conceitual.md` - Diagrama ER e entidades
- **Modelo Lógico**: `specs/02_modelo_logico.md` - Tabelas, atributos e relacionamentos
- **Modelo Físico**: `specs/03_modelo_fisico.md` - SQL, tipos de dados, constraints, triggers e migrations
- **Consultas SQL**: `src/database/queries/` - Todas as queries obrigatórias (Q1 a Q5)

---

## ⚙️ Troubleshooting

### O container não sobe

```bash
docker-compose logs postgres
```

Se houver erro, tente:
```bash
docker-compose down -v
docker-compose up -d
```

### Erro de conexão

Verifique se a porta 5432 está livre:
```bash
lsof -i :5432
```

Se estiver ocupada, edite `docker-compose.yaml` e altere a porta (ex: `5433:5432`).

### Resetar o banco completamente

```bash
docker-compose down -v
docker-compose up -d
```
