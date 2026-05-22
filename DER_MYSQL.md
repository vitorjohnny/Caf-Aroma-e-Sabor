# 🗄️ DER MySQL - Produto e Movimentação

## 📊 Diagrama Entidade-Relacionamento no MySQL

```
┌──────────────────────────────────────┐
│          USUARIO (Tabela)            │
├──────────────────────────────────────┤
│ id (BIGINT, PK, AUTO_INCREMENT)      │
│ email (VARCHAR(255), UNIQUE, NOT NULL)
│ nome (VARCHAR(255), NOT NULL)        │
│ senha (VARCHAR(255), NOT NULL)       │
│ created_at (TIMESTAMP)               │
│ INDEX: idx_email                     │
└──────────────────────────────────────┘
              ▲
              │ 1 (Um usuário)
              │
              │
              ├─── FOREIGN KEY (usuario_id)
              │    DELETE: RESTRICT
              │    UPDATE: CASCADE
              │
              │
              ▼
┌──────────────────────────────────────────────────────┐
│        MOVIMENTACAO (Tabela - Central)               │
├──────────────────────────────────────────────────────┤
│ id (BIGINT, PK, AUTO_INCREMENT)                      │
│ tipo_movimentacao (VARCHAR(50), NOT NULL)            │
│ quantidade (INT, NOT NULL)                           │
│ data_mov (DATETIME, NOT NULL)                        │
│ observacao (VARCHAR(500))                            │
│ produto_id (BIGINT, FK, NOT NULL)  ─────────────┐   │
│ usuario_id (BIGINT, FK, NOT NULL)  ──────┐      │   │
│ created_at (TIMESTAMP)                    │      │   │
│ INDEXES:                                  │      │   │
│  - idx_produto_id                         │      │   │
│  - idx_usuario_id                         │      │   │
│  - idx_data_mov                           │      │   │
│  - idx_tipo_movimentacao                  │      │   │
│  - idx_movimentacao_produto_data (composto)       │   │
└──────────────────────────────────────────────────────┘
              │                         │
              │ N (Muitas movimentações)│
              │                         │
              │                         │
              │ FOREIGN KEY             │ FOREIGN KEY
              │ (produto_id)            │ (usuario_id)
              │ DELETE: CASCADE         │ DELETE: RESTRICT
              │ UPDATE: CASCADE         │ UPDATE: CASCADE
              │                         │
              │                         │
              ▼                         ▼
┌──────────────────────────────────────┐ │
│        PRODUTO (Tabela)              │ │
├──────────────────────────────────────┤ │
│ id (BIGINT, PK, AUTO_INCREMENT)      │ │
│ nome (VARCHAR(255), NOT NULL)        │ │
│ descricao (VARCHAR(500))             │ │
│ categoria (VARCHAR(100))             │ │
│ unidade_medida (VARCHAR(50))         │ │
│ preco (DECIMAL(10,2))                │ │
│ estoque (INT, DEFAULT 0)             │ │
│ estoque_minimo (INT, DEFAULT 0)      │ │
│ lote (VARCHAR(100))                  │ │
│ data_validade (DATE)                 │ │
│ created_at (TIMESTAMP)               │ │
│ updated_at (TIMESTAMP)               │ │
│ INDEX: idx_categoria                 │ │
│ INDEX: idx_nome                      │ │
└──────────────────────────────────────┘ │
              ▲                          │
              │                          │
              └──────────────────────────┘
                  (Referência da FK)
```

---

## 🔑 Relacionamentos

### 1️⃣ PRODUTO ◄──── 1:N ───► MOVIMENTACAO

```sql
ALTER TABLE movimentacao
ADD CONSTRAINT fk_movimentacao_produto
FOREIGN KEY (produto_id)
REFERENCES produto(id)
ON DELETE CASCADE
ON UPDATE CASCADE;
```

**Significado:**
- Um PRODUTO pode ter MUITAS MOVIMENTAÇÕEs
- Uma MOVIMENTAÇÃO pertence a UM PRODUTO
- Se um PRODUTO for deletado, suas MOVIMENTAÇÕES também serão (CASCADE)
- Se o ID do PRODUTO mudar, as MOVIMENTAÇÕES serão atualizadas

---

### 2️⃣ USUARIO ◄──── 1:N ───► MOVIMENTACAO

```sql
ALTER TABLE movimentacao
ADD CONSTRAINT fk_movimentacao_usuario
FOREIGN KEY (usuario_id)
REFERENCES usuario(id)
ON DELETE RESTRICT
ON UPDATE CASCADE;
```

**Significado:**
- Um USUARIO pode fazer MUITAS MOVIMENTAÇÕEs
- Uma MOVIMENTAÇÃO é feita por UM USUARIO
- Não é permitido deletar um USUARIO se tiver MOVIMENTAÇÕES (RESTRICT)
- Se o ID do USUARIO mudar, as MOVIMENTAÇÕES serão atualizadas

---

## 📋 Definições das Tabelas no MySQL

### Tabela: USUARIO

```sql
CREATE TABLE usuario (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) UNIQUE NOT NULL,
    nome VARCHAR(255) NOT NULL,
    senha VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

| Campo | Tipo | Constraints | Descrição |
|-------|------|-----------|-----------|
| id | BIGINT | PK, AUTO_INCREMENT | Identificador único |
| email | VARCHAR(255) | UNIQUE, NOT NULL | Email único |
| nome | VARCHAR(255) | NOT NULL | Nome completo |
| senha | VARCHAR(255) | NOT NULL | Senha criptografada |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Data de criação |

---

### Tabela: PRODUTO

```sql
CREATE TABLE produto (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    descricao VARCHAR(500),
    categoria VARCHAR(100),
    unidade_medida VARCHAR(50),
    preco DECIMAL(10, 2),
    estoque INT DEFAULT 0,
    estoque_minimo INT DEFAULT 0,
    lote VARCHAR(100),
    data_validade DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_categoria (categoria),
    INDEX idx_nome (nome)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

| Campo | Tipo | Constraints | Descrição |
|-------|------|-----------|-----------|
| id | BIGINT | PK, AUTO_INCREMENT | Identificador único |
| nome | VARCHAR(255) | NOT NULL | Nome do produto |
| descricao | VARCHAR(500) | | Descrição |
| categoria | VARCHAR(100) | INDEX | Categoria (para busca rápida) |
| unidade_medida | VARCHAR(50) | | Unidade (kg, L, un, etc) |
| preco | DECIMAL(10,2) | | Preço unitário |
| estoque | INT | DEFAULT 0 | Quantidade em estoque |
| estoque_minimo | INT | DEFAULT 0 | Estoque mínimo |
| lote | VARCHAR(100) | | Número do lote |
| data_validade | DATE | | Data de validade |
| created_at | TIMESTAMP | | Data de criação |
| updated_at | TIMESTAMP | | Data de última atualização |

---

### Tabela: MOVIMENTACAO (Principal)

```sql
CREATE TABLE movimentacao (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    tipo_movimentacao VARCHAR(50) NOT NULL,
    quantidade INT NOT NULL,
    data_mov DATETIME NOT NULL,
    observacao VARCHAR(500),
    produto_id BIGINT NOT NULL,
    usuario_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_movimentacao_produto 
        FOREIGN KEY (produto_id) REFERENCES produto(id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    
    CONSTRAINT fk_movimentacao_usuario 
        FOREIGN KEY (usuario_id) REFERENCES usuario(id) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    INDEX idx_produto_id (produto_id),
    INDEX idx_usuario_id (usuario_id),
    INDEX idx_data_mov (data_mov),
    INDEX idx_tipo_movimentacao (tipo_movimentacao),
    INDEX idx_movimentacao_produto_data (produto_id, data_mov)
    
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

| Campo | Tipo | Constraints | Descrição |
|-------|------|-----------|-----------|
| id | BIGINT | PK, AUTO_INCREMENT | Identificador único |
| tipo_movimentacao | VARCHAR(50) | NOT NULL, INDEX | ENTRADA, SAIDA, DEVOLUCAO, AJUSTE |
| quantidade | INT | NOT NULL | Quantidade movimentada |
| data_mov | DATETIME | NOT NULL, INDEX | Data e hora da operação |
| observacao | VARCHAR(500) | | Notas adicionais |
| produto_id | BIGINT | NOT NULL, FK, INDEX | Referência ao produto |
| usuario_id | BIGINT | NOT NULL, FK, INDEX | Referência ao usuário |
| created_at | TIMESTAMP | | Data de criação do registro |

---

## 🔗 Foreign Keys Explicadas

### FK: fk_movimentacao_produto

```
Origem:      movimentacao.produto_id
Destino:     produto.id
Cardinalidade: N:1 (Muitos para Um)

ON DELETE CASCADE:
  └─ Se um PRODUTO é deletado, todas suas MOVIMENTAÇÕES também são
  └─ Usado porque movimentações sem produto não fazem sentido
  
ON UPDATE CASCADE:
  └─ Se o ID do PRODUTO muda, atualiza em MOVIMENTACAO também
  └─ Mantém a integridade referencial
```

**Exemplo:**
```sql
DELETE FROM produto WHERE id = 1;
-- Resultado: Todas as movimentações com produto_id = 1 também serão deletadas
```

---

### FK: fk_movimentacao_usuario

```
Origem:      movimentacao.usuario_id
Destino:     usuario.id
Cardinalidade: N:1 (Muitos para Um)

ON DELETE RESTRICT:
  └─ NÃO permite deletar um USUARIO se tiver MOVIMENTAÇÕES
  └─ Protege a auditoria (quem fez o que)
  
ON UPDATE CASCADE:
  └─ Se o ID do USUARIO muda, atualiza em MOVIMENTACAO também
  └─ Mantém a integridade referencial
```

**Exemplo:**
```sql
DELETE FROM usuario WHERE id = 1;
-- Resultado: ERROR 1451 - Cannot delete or update a parent row: a foreign key constraint fails

-- Solução: Primeiro deletar as movimentações
DELETE FROM movimentacao WHERE usuario_id = 1;
DELETE FROM usuario WHERE id = 1;  -- Agora funciona
```

---

## 📈 Índices para Performance

### Índices na Tabela MOVIMENTACAO

```
┌─────────────────────────────────────────────────────────┐
│ Índice | Coluna(s) | Tipo | Uso                         │
├─────────────────────────────────────────────────────────┤
│ PRIMARY KEY | id | Único | Identificação rápida        │
├─────────────────────────────────────────────────────────┤
│ idx_produto_id | produto_id | Simple | Buscar por prod │
├─────────────────────────────────────────────────────────┤
│ idx_usuario_id | usuario_id | Simple | Buscar por usuário │
├─────────────────────────────────────────────────────────┤
│ idx_data_mov | data_mov | Simple | Buscar por data    │
├─────────────────────────────────────────────────────────┤
│ idx_tipo_movimentacao | tipo_movimentacao | Simple | Filtrar por tipo │
├─────────────────────────────────────────────────────────┤
│ idx_movimentacao_produto_data | produto_id, data_mov | Composto │ Busca otimizada │
└─────────────────────────────────────────────────────────┘
```

**Consultas Otimizadas pelos Índices:**

```sql
-- Usa: idx_produto_id
SELECT * FROM movimentacao WHERE produto_id = 1;

-- Usa: idx_usuario_id
SELECT * FROM movimentacao WHERE usuario_id = 2;

-- Usa: idx_data_mov
SELECT * FROM movimentacao WHERE data_mov >= '2026-05-01';

-- Usa: idx_tipo_movimentacao
SELECT * FROM movimentacao WHERE tipo_movimentacao = 'ENTRADA';

-- Usa: idx_movimentacao_produto_data (composto)
SELECT * FROM movimentacao 
WHERE produto_id = 1 AND data_mov BETWEEN '2026-05-01' AND '2026-05-31';
```

---

## 💾 Valores Possíveis

### tipo_movimentacao (Enum simulado)

```
┌──────────────┬─────────────────────────────────┬────────────────────┐
│ Tipo         │ Descrição                       │ Impacto no Estoque │
├──────────────┼─────────────────────────────────┼────────────────────┤
│ ENTRADA      │ Entrada de estoque              │ AUMENTA (+)        │
│ SAIDA        │ Saída de estoque                │ DIMINUI (-)        │
│ DEVOLUCAO    │ Devolução de cliente            │ AUMENTA (+)        │
│ AJUSTE       │ Ajuste de inventário            │ AUMENTA/DIMINUI    │
└──────────────┴─────────────────────────────────┴────────────────────┘
```

---

## 🔍 Consultas Úteis no MySQL

### 1. Ver Estrutura da Tabela

```sql
DESCRIBE movimentacao;
-- ou
SHOW COLUMNS FROM movimentacao;
```

### 2. Ver Foreign Keys

```sql
SELECT CONSTRAINT_NAME, TABLE_NAME, COLUMN_NAME, REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_NAME = 'movimentacao' AND COLUMN_NAME LIKE '%id';
```

### 3. Ver Índices

```sql
SHOW INDEXES FROM movimentacao;
```

### 4. Movimentações com Joins

```sql
SELECT 
    m.id,
    m.tipo_movimentacao,
    m.quantidade,
    m.data_mov,
    p.nome AS produto,
    p.estoque,
    u.nome AS usuario,
    m.observacao
FROM movimentacao m
INNER JOIN produto p ON m.produto_id = p.id
INNER JOIN usuario u ON m.usuario_id = u.id
ORDER BY m.data_mov DESC;
```

### 5. Histórico de um Produto

```sql
SELECT 
    m.id,
    m.tipo_movimentacao,
    m.quantidade,
    m.data_mov,
    u.nome AS usuario
FROM movimentacao m
INNER JOIN usuario u ON m.usuario_id = u.id
WHERE m.produto_id = 1
ORDER BY m.data_mov DESC;
```

---

## 🛠️ Manutenção do Banco

### Adicionar um Novo Tipo de Movimentação

Não é necessário alterar a tabela! Basta inserir novos registros com o novo tipo:

```sql
INSERT INTO movimentacao (tipo_movimentacao, quantidade, data_mov, produto_id, usuario_id, observacao)
VALUES ('TRANSFERENCIA', 10, NOW(), 1, 2, 'Transferência entre estoques');
```

### Listar Todos os Tipos Utilizados

```sql
SELECT DISTINCT tipo_movimentacao FROM movimentacao ORDER BY tipo_movimentacao;
```

### Contar Movimentações por Tipo

```sql
SELECT 
    tipo_movimentacao,
    COUNT(*) as total,
    SUM(quantidade) as quantidade_total
FROM movimentacao
GROUP BY tipo_movimentacao
ORDER BY total DESC;
```

---

## ✅ Verificação de Integridade

### Validar Referential Integrity

```sql
-- Movimentações órfãs (produto deletado)
SELECT * FROM movimentacao WHERE produto_id NOT IN (SELECT id FROM produto);

-- Movimentações órfãs (usuário deletado)
SELECT * FROM movimentacao WHERE usuario_id NOT IN (SELECT id FROM usuario);
```

### Corrigir Referential Integrity

```sql
-- Deletar movimentações órfãs
DELETE FROM movimentacao 
WHERE produto_id NOT IN (SELECT id FROM produto);

DELETE FROM movimentacao 
WHERE usuario_id NOT IN (SELECT id FROM usuario);
```

---

## 📊 Estatísticas

### Tamanho da Tabela

```sql
SELECT 
    TABLE_NAME,
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS size_mb
FROM information_schema.tables
WHERE table_schema = 'cafe'
ORDER BY size_mb DESC;
```

### Número de Registros

```sql
SELECT 
    'usuario' as tabela, COUNT(*) as registros FROM usuario
UNION
SELECT 'produto', COUNT(*) FROM produto
UNION
SELECT 'movimentacao', COUNT(*) FROM movimentacao;
```

---

## 🔐 Backup e Restore

### Exportar Estrutura

```bash
# Exportar apenas a estrutura
mysqldump -u user -p cafe --no-data > cafe_structure.sql

# Exportar estrutura + dados
mysqldump -u user -p cafe > cafe_backup.sql
```

### Restaurar

```bash
mysql -u user -p cafe < cafe_backup.sql
```

---

## 📌 Resumo do DER no MySQL

```
Tabelas:         3 (USUARIO, PRODUTO, MOVIMENTACAO)
Relacionamentos: 2 (PRODUTO←→MOVIMENTACAO, USUARIO←→MOVIMENTACAO)
Chaves Estrangeiras: 2
Índices:         8 (1 PK + 7 secundários)
Engine:          InnoDB (suporta FK)
Charset:         utf8mb4 (suporta acentos e emojis)
Collation:       utf8mb4_unicode_ci (case-insensitive)
```

---

**Status**: ✅ Pronto para Produção  
**Versão**: 1.0  
**Data**: 22/05/2026

