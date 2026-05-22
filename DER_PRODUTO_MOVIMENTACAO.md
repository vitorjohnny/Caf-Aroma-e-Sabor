# DER - Diagrama Entidade-Relacionamento
## Café - Sistema de Gestão de Estoque

---

## 📊 Diagrama Visual

```
┌─────────────────────────────────────────┐
│              USUARIO                     │
├─────────────────────────────────────────┤
│ PK │ id                     BIGINT       │
│    │ email                  VARCHAR(255) │
│    │ nome                   VARCHAR(255) │
│    │ senha                  VARCHAR(255) │
└─────────────────────────────────────────┘
            │
            │ 1:N
            │
            └─────────────────────────────┐
                                          │
┌─────────────────────────────────────────────────┐
│           MOVIMENTACAO                          │
├─────────────────────────────────────────────────┤
│ PK │ id                  BIGINT                 │
│    │ tipoMovimentacao    VARCHAR(50)            │
│    │ quantidade          INT                    │
│    │ dataMov             DATETIME               │
│    │ observacao          VARCHAR(500)           │
│ FK │ produto_id          BIGINT                 │
│ FK │ usuario_id          BIGINT                 │
└─────────────────────────────────────────────────┘
            │
            │ N:1
            │
            └─────────────────────────────┐
                                          │
┌──────────────────────────────────────────────────┐
│             PRODUTO                             │
├──────────────────────────────────────────────────┤
│ PK │ id                  BIGINT                 │
│    │ nome                VARCHAR(255)           │
│    │ descricao           VARCHAR(500)           │
│    │ categoria           VARCHAR(100)           │
│    │ unidadeMedida       VARCHAR(50)            │
│    │ preco               DECIMAL(10, 2)         │
│    │ estoque             INT                    │
│    │ estoqueMinimo       INT                    │
│    │ lote                VARCHAR(100)           │
│    │ dataValidade        DATE                   │
└──────────────────────────────────────────────────┘
```

---

## 📋 Descrição das Tabelas

### PRODUTO
Armazena os produtos do café.

| Campo | Tipo | Descrição |
|-------|------|-----------|
| id | BIGINT | Identificador único (PK) |
| nome | VARCHAR(255) | Nome do produto |
| descricao | VARCHAR(500) | Descrição detalhada |
| categoria | VARCHAR(100) | Categoria do produto |
| unidadeMedida | VARCHAR(50) | Unidade de medida (kg, L, un, etc) |
| preco | DECIMAL(10, 2) | Preço unitário |
| estoque | INT | Quantidade em estoque |
| estoqueMinimo | INT | Quantidade mínima permitida |
| lote | VARCHAR(100) | Número do lote |
| dataValidade | DATE | Data de validade |

### USUARIO
Armazena os usuários do sistema.

| Campo | Tipo | Descrição |
|-------|------|-----------|
| id | BIGINT | Identificador único (PK) |
| email | VARCHAR(255) | Email único do usuário |
| nome | VARCHAR(255) | Nome completo |
| senha | VARCHAR(255) | Senha criptografada |

### MOVIMENTACAO
Registra todas as movimentações de estoque.

| Campo | Tipo | Descrição |
|-------|------|-----------|
| id | BIGINT | Identificador único (PK) |
| tipoMovimentacao | VARCHAR(50) | Tipo: ENTRADA, SAIDA, DEVOLUCAO, AJUSTE |
| quantidade | INT | Quantidade movimentada |
| dataMov | DATETIME | Data e hora da movimentação |
| observacao | VARCHAR(500) | Observações adicionais |
| produto_id | BIGINT | Referência ao PRODUTO (FK) |
| usuario_id | BIGINT | Referência ao USUARIO (FK) |

---

## 🔗 Relacionamentos

### PRODUTO (1) ─── (N) MOVIMENTACAO
- Um produto pode ter várias movimentações
- Cada movimentação pertence a um único produto
- Tipo: OneToMany (Produto.movimentacoes) ↔ ManyToOne (Movimentacao.produto)

### USUARIO (1) ─── (N) MOVIMENTACAO
- Um usuário pode fazer várias movimentações
- Cada movimentação é registrada por um único usuário
- Tipo: OneToMany (Usuario.movimentacoes) ↔ ManyToOne (Movimentacao.usuario)

---

## 📝 Script SQL de Criação

```sql
-- Tabela USUARIO
CREATE TABLE usuario (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) UNIQUE NOT NULL,
    nome VARCHAR(255) NOT NULL,
    senha VARCHAR(255) NOT NULL
);

-- Tabela PRODUTO
CREATE TABLE produto (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    descricao VARCHAR(500),
    categoria VARCHAR(100),
    unidade_medida VARCHAR(50),
    preco DECIMAL(10, 2),
    estoque INT,
    estoque_minimo INT,
    lote VARCHAR(100),
    data_validade DATE
);

-- Tabela MOVIMENTACAO
CREATE TABLE movimentacao (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    tipo_movimentacao VARCHAR(50) NOT NULL,
    quantidade INT NOT NULL,
    data_mov DATETIME NOT NULL,
    observacao VARCHAR(500),
    produto_id BIGINT NOT NULL,
    usuario_id BIGINT NOT NULL,
    FOREIGN KEY (produto_id) REFERENCES produto(id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE RESTRICT,
    INDEX idx_produto_id (produto_id),
    INDEX idx_usuario_id (usuario_id),
    INDEX idx_data_mov (data_mov)
);

-- Índices para melhor performance
CREATE INDEX idx_movimentacao_produto_data 
    ON movimentacao(produto_id, data_mov);
```

---

## 🎯 Tipos de Movimentação

- **ENTRADA**: Entrada de estoque (compra, produção)
- **SAIDA**: Saída de estoque (venda, consumo)
- **DEVOLUCAO**: Devolução de produto
- **AJUSTE**: Ajuste de estoque (inventário)

---

## ✅ Integridade e Constraints

- **Chave Primária (PK)**: id em cada tabela (BIGINT, AUTO_INCREMENT)
- **Chave Estrangeira (FK)**: 
  - movimentacao.produto_id → produto.id (ON DELETE CASCADE)
  - movimentacao.usuario_id → usuario.id (ON DELETE RESTRICT)
- **Constraints de Não-Nulidade**:
  - PRODUTO: nome
  - USUARIO: email, nome, senha
  - MOVIMENTACAO: tipoMovimentacao, quantidade, dataMov, produto_id, usuario_id
- **Unicidade**: usuario.email
- **Índices**: Para otimizar buscas frequentes

---

## 🔄 Fluxo de Movimentação

```
1. Usuário autentica no sistema
2. Usuário registra uma movimentação de estoque
3. Sistema cria registro em MOVIMENTACAO
4. Sistema atualiza quantidade em PRODUTO.estoque
5. Movimentação fica registrada para auditoria
```

---

## 📌 Observações

- Todas as movimentações são registradas com o usuário que realizou a ação para auditoria
- O campo dataValidade em PRODUTO é importante para controle de validade
- O estoqueMinimo serve para alertar quando está baixo
- As movimentações fornecem histórico completo de todas as operações de estoque

