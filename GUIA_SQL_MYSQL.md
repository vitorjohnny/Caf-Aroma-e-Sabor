# 🗄️ Guia de Execução do Script SQL - Movimentação

## 📌 Como Executar o DER no MySQL

### Opção 1: MySQL Command Line

#### Passo 1: Conectar ao MySQL

```bash
mysql -u seu_usuario -p
# Insira sua senha quando solicitado
```

#### Passo 2: Criar o Database

```sql
CREATE DATABASE cafe CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE cafe;
```

#### Passo 3: Executar o Script SQL

```sql
-- Copie e cole o conteúdo de db_schema.sql aqui
-- OU use o comando:

source /caminho/para/db_schema.sql;
```

#### Passo 4: Validar a Criação

```sql
-- Ver tabelas criadas
SHOW TABLES;

-- Ver estrutura de cada tabela
DESCRIBE usuario;
DESCRIBE produto;
DESCRIBE movimentacao;

-- Ver foreign keys
SELECT CONSTRAINT_NAME, TABLE_NAME, COLUMN_NAME, REFERENCED_TABLE_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'cafe' AND COLUMN_NAME LIKE '%id';

-- Ver dados inseridos
SELECT * FROM usuario;
SELECT * FROM produto;
SELECT * FROM movimentacao;
```

---

### Opção 2: MySQL Workbench

#### Passo 1: Abrir MySQL Workbench

1. Iniciar MySQL Workbench
2. Conectar a um servidor MySQL

#### Passo 2: Criar Database

```sql
CREATE DATABASE cafe CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

#### Passo 3: Usar o Database

```sql
USE cafe;
```

#### Passo 4: Executar Script

1. Ir em `File` → `Open SQL Script`
2. Selecionar `db_schema.sql`
3. Executar com `Cmd+Enter` (Mac) ou `Ctrl+Enter` (Windows)

---

### Opção 3: PHP MyAdmin

#### Passo 1: Acessar phpMyAdmin

Abrir no navegador: `http://localhost/phpmyadmin`

#### Passo 2: Criar Database

1. Clicar em `Novo`
2. Nome: `cafe`
3. Collation: `utf8mb4_unicode_ci`
4. Criar

#### Passo 3: Executar Script

1. Selecionar database `cafe`
2. Ir para `SQL`
3. Copiar e colar o script SQL
4. Executar

---

### Opção 4: Linha de Comando (One-liner)

```bash
# Windows PowerShell
mysql -u root -p < "C:\Users\49198390813\Documents\JAVA V\cafe\src\main\resources\db_schema.sql"

# Linux/Mac
mysql -u root -p < "/path/to/db_schema.sql"
```

---

## ✅ Checklist de Verificação

Após executar o script, valide:

### 1. Tabelas Criadas

```sql
SELECT TABLE_NAME, TABLE_TYPE, TABLE_COLLATION
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'cafe'
ORDER BY TABLE_NAME;
```

**Resultado esperado:**
```
TABLE_NAME      | TABLE_TYPE | TABLE_COLLATION
────────────────┼────────────┼─────────────────────
movimentacao    | BASE TABLE | utf8mb4_unicode_ci
produto         | BASE TABLE | utf8mb4_unicode_ci
usuario         | BASE TABLE | utf8mb4_unicode_ci
```

### 2. Colunas da Tabela MOVIMENTACAO

```sql
DESCRIBE movimentacao;
```

**Resultado esperado:**
```
Field               | Type        | Null | Key | Default           | Extra
────────────────────┼─────────────┼──────┼─────┼───────────────────┼──────
id                  | bigint      | NO   | PRI | NULL              | auto_increment
tipo_movimentacao   | varchar(50) | NO   | MUL | NULL              |
quantidade          | int         | NO   |     | NULL              |
data_mov            | datetime    | NO   | MUL | NULL              |
observacao          | varchar(500)| YES  |     | NULL              |
produto_id          | bigint      | NO   | MUL | NULL              |
usuario_id          | bigint      | NO   | MUL | NULL              |
created_at          | timestamp   | NO   |     | CURRENT_TIMESTAMP |
```

### 3. Foreign Keys

```sql
SELECT CONSTRAINT_NAME, TABLE_NAME, COLUMN_NAME, REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_NAME = 'movimentacao'
ORDER BY CONSTRAINT_NAME;
```

**Resultado esperado:**
```
CONSTRAINT_NAME              | TABLE_NAME    | COLUMN_NAME | REFERENCED_TABLE | REFERENCED_COLUMN
─────────────────────────────┼───────────────┼─────────────┼──────────────────┼──────────────────
fk_movimentacao_produto      | movimentacao  | produto_id  | produto          | id
fk_movimentacao_usuario      | movimentacao  | usuario_id  | usuario          | id
PRIMARY                      | movimentacao  | id          | NULL             | NULL
```

### 4. Índices

```sql
SHOW INDEXES FROM movimentacao;
```

**Resultado esperado:**
```
Table          | Non_unique | Key_name                        | Column_name | Seq_in_index
───────────────┼────────────┼─────────────────────────────────┼─────────────┼──────────────
movimentacao   | 0          | PRIMARY                         | id          | 1
movimentacao   | 1          | idx_data_mov                    | data_mov    | 1
movimentacao   | 1          | idx_movimentacao_produto_data   | produto_id  | 1
movimentacao   | 1          | idx_movimentacao_produto_data   | data_mov    | 2
movimentacao   | 1          | idx_produto_id                  | produto_id  | 1
movimentacao   | 1          | idx_tipo_movimentacao           | tipo_mov    | 1
movimentacao   | 1          | idx_usuario_id                  | usuario_id  | 1
```

### 5. Dados de Exemplo

```sql
-- Verificar dados inseridos
SELECT COUNT(*) FROM usuario;
SELECT COUNT(*) FROM produto;
SELECT COUNT(*) FROM movimentacao;
```

**Resultado esperado:**
```
COUNT(*) from usuario         = 3
COUNT(*) from produto         = 4
COUNT(*) from movimentacao    = 6
```

---

## 🔧 Troubleshooting

### Erro: "Table already exists"

**Problema**: Tabelas já foram criadas antes

**Solução 1**: Deletar o database e recriar
```sql
DROP DATABASE IF EXISTS cafe;
CREATE DATABASE cafe CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE cafe;
-- Executar script SQL novamente
```

**Solução 2**: Usar IF NOT EXISTS no script

### Erro: "Foreign key constraint fails"

**Problema**: Tentando inserir um relacionamento inválido

**Exemplo**:
```sql
-- ERRO: produto_id = 999 não existe
INSERT INTO movimentacao (tipo_movimentacao, quantidade, data_mov, produto_id, usuario_id)
VALUES ('ENTRADA', 10, NOW(), 999, 1);
```

**Solução**: Garantir que os IDs existem
```sql
-- Verificar produtos existentes
SELECT id FROM produto;

-- Verificar usuários existentes
SELECT id FROM usuario;
```

### Erro: "Cannot delete or update a parent row"

**Problema**: Tentando deletar usuário ou produto com movimentações

**Exemplo**:
```sql
-- ERRO: Usuário 1 tem movimentações
DELETE FROM usuario WHERE id = 1;
```

**Solução**: Deletar movimentações primeiro
```sql
-- Deletar movimentações do usuário
DELETE FROM movimentacao WHERE usuario_id = 1;

-- Agora pode deletar o usuário
DELETE FROM usuario WHERE id = 1;
```

### Erro: "Duplicate entry"

**Problema**: Email duplicado em usuários

**Exemplo**:
```sql
-- ERRO: Email 'admin@cafe.com' já existe
INSERT INTO usuario (email, nome, senha) VALUES ('admin@cafe.com', 'Admin2', 'senha');
```

**Solução**: Usar email único
```sql
-- Usar email único
INSERT INTO usuario (email, nome, senha) VALUES ('newemail@cafe.com', 'Admin2', 'senha');
```

---

## 🧪 Testes de Validação

### Teste 1: Registrar Movimentação Válida

```sql
-- DEVE FUNCIONAR
INSERT INTO movimentacao (tipo_movimentacao, quantidade, data_mov, produto_id, usuario_id, observacao)
VALUES ('ENTRADA', 50, '2026-05-23 10:00:00', 1, 1, 'Compra teste');

-- Verificar inserção
SELECT * FROM movimentacao WHERE id = (SELECT MAX(id) FROM movimentacao);
```

### Teste 2: Tentar Inserção Inválida

```sql
-- DEVE FALHAR: produto_id não existe
INSERT INTO movimentacao (tipo_movimentacao, quantidade, data_mov, produto_id, usuario_id)
VALUES ('ENTRADA', 10, NOW(), 999, 1);
-- ERROR 1452: Cannot add or update a child row

-- DEVE FALHAR: usuario_id não existe
INSERT INTO movimentacao (tipo_movimentacao, quantidade, data_mov, produto_id, usuario_id)
VALUES ('ENTRADA', 10, NOW(), 1, 999);
-- ERROR 1452: Cannot add or update a child row

-- DEVE FALHAR: email duplicado
INSERT INTO usuario (email, nome, senha) VALUES ('admin@cafe.com', 'Admin3', 'senha');
-- ERROR 1062: Duplicate entry
```

### Teste 3: Cascade Delete

```sql
-- Contar movimentações do produto 1
SELECT COUNT(*) FROM movimentacao WHERE produto_id = 1;
-- Resultado: 3

-- Deletar produto 1
DELETE FROM produto WHERE id = 1;

-- Verificar se movimentações foram deletadas
SELECT COUNT(*) FROM movimentacao WHERE produto_id = 1;
-- Resultado: 0 (Cascade funcionou!)
```

### Teste 4: Restrict Delete

```sql
-- Tentar deletar usuário 2 que tem movimentações
DELETE FROM usuario WHERE id = 2;
-- ERROR 1451: Cannot delete or update a parent row: a foreign key constraint fails

-- Para deletar, precisa remover as movimentações primeiro
DELETE FROM movimentacao WHERE usuario_id = 2;
DELETE FROM usuario WHERE id = 2;
-- OK!
```

---

## 📊 Consultas Úteis para Validação

### 1. Ver Todas as Movimentações com Details

```sql
SELECT 
    m.id,
    p.nome AS produto,
    m.tipo_movimentacao,
    m.quantidade,
    m.data_mov,
    u.nome AS usuario,
    m.observacao
FROM movimentacao m
INNER JOIN produto p ON m.produto_id = p.id
INNER JOIN usuario u ON m.usuario_id = u.id
ORDER BY m.data_mov DESC;
```

### 2. Histórico de um Produto Específico

```sql
SELECT 
    m.id,
    m.tipo_movimentacao,
    m.quantidade,
    m.data_mov,
    u.nome AS usuario,
    m.observacao
FROM movimentacao m
INNER JOIN usuario u ON m.usuario_id = u.id
WHERE m.produto_id = 1
ORDER BY m.data_mov DESC;
```

### 3. Total de Movimentações por Tipo

```sql
SELECT 
    tipo_movimentacao,
    COUNT(*) AS total,
    SUM(quantidade) AS quantidade_total
FROM movimentacao
GROUP BY tipo_movimentacao
ORDER BY total DESC;
```

### 4. Estoque Atual vs Mínimo

```sql
SELECT 
    nome,
    estoque,
    estoque_minimo,
    CASE 
        WHEN estoque <= estoque_minimo THEN 'CRÍTICO'
        WHEN estoque < estoque_minimo * 2 THEN 'BAIXO'
        ELSE 'OK'
    END AS status
FROM produto
ORDER BY estoque ASC;
```

---

## 📈 Performance Check

### 1. Tamanho do Database

```sql
SELECT 
    TABLE_NAME,
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS size_mb
FROM information_schema.tables
WHERE table_schema = 'cafe'
ORDER BY size_mb DESC;
```

### 2. Estatísticas de Índices

```sql
SELECT 
    OBJECT_SCHEMA,
    OBJECT_NAME,
    COUNT_READ,
    COUNT_WRITE,
    COUNT_DELETE,
    COUNT_INSERT,
    COUNT_UPDATE
FROM performance_schema.table_io_waits_summary_by_table
WHERE OBJECT_SCHEMA = 'cafe'
ORDER BY COUNT_READ DESC;
```

---

## 🎯 Próximos Passos

Após validar o DER no MySQL:

1. ✅ **Banco de Dados Criado** - DER pronto
2. ⏳ **Conectar Spring Boot** - Configurar `application.properties`
3. ⏳ **Implementar Services** - Lógica de negócio
4. ⏳ **Criar Controllers** - API REST
5. ⏳ **Desenvolver Views** - Interface Web

---

## 📞 Referências

- **Script SQL**: `db_schema.sql`
- **DER Documento**: `DER_MYSQL.md`
- **DER Visual**: `DER_MYSQL_VISUAL.txt`
- **Especificação**: `ESPECIFICACAO_DER.md`

---

**Status**: ✅ Pronto para Execução  
**Data**: 22/05/2026  
**Versão**: 1.0

