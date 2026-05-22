# 🎯 QUICK START - DER Movimentação no MySQL

## ⚡ 5 Minutos para Começar

### 1️⃣ Criar o Banco

```bash
mysql -u root -p
```

```sql
CREATE DATABASE cafe CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE cafe;
```

### 2️⃣ Executar o Script SQL

**Copie e cole TODO o conteúdo de `db_schema.sql`:**

```sql
-- Tabela USUARIO
CREATE TABLE usuario (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) UNIQUE NOT NULL,
    nome VARCHAR(255) NOT NULL,
    senha VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabela PRODUTO
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

-- Tabela MOVIMENTACAO (Principal)
CREATE TABLE movimentacao (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    tipo_movimentacao VARCHAR(50) NOT NULL,
    quantidade INT NOT NULL,
    data_mov DATETIME NOT NULL,
    observacao VARCHAR(500),
    produto_id BIGINT NOT NULL,
    usuario_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_movimentacao_produto FOREIGN KEY (produto_id) 
        REFERENCES produto(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_movimentacao_usuario FOREIGN KEY (usuario_id) 
        REFERENCES usuario(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    
    INDEX idx_produto_id (produto_id),
    INDEX idx_usuario_id (usuario_id),
    INDEX idx_data_mov (data_mov),
    INDEX idx_tipo_movimentacao (tipo_movimentacao),
    INDEX idx_movimentacao_produto_data (produto_id, data_mov)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Inserir dados de exemplo
INSERT INTO usuario (email, nome, senha) VALUES
('admin@cafe.com', 'Administrador', 'senha_hash_aqui'),
('gerente@cafe.com', 'Gerente de Estoque', 'senha_hash_aqui'),
('operador@cafe.com', 'Operador de Estoque', 'senha_hash_aqui');

INSERT INTO produto (nome, descricao, categoria, unidade_medida, preco, estoque, estoque_minimo, lote, data_validade)
VALUES
('Café Premium', 'Café especial importado', 'Bebidas', 'kg', 45.90, 100, 20, 'LOTE001', '2026-12-31'),
('Açúcar Cristal', 'Açúcar cristal refinado', 'Ingredientes', 'kg', 3.50, 500, 100, 'LOTE002', '2027-06-30'),
('Leite Integral', 'Leite integral fresco', 'Bebidas', 'L', 5.00, 200, 50, 'LOTE003', '2026-06-15'),
('Biscoito Amanteigado', 'Biscoito amanteigado crocante', 'Alimentos', 'un', 12.50, 150, 30, 'LOTE004', '2027-03-20');

INSERT INTO movimentacao (tipo_movimentacao, quantidade, data_mov, observacao, produto_id, usuario_id)
VALUES
('ENTRADA', 50, '2026-05-20 08:00:00', 'Compra fornecedor', 1, 1),
('ENTRADA', 200, '2026-05-20 09:30:00', 'Compra fornecedor', 2, 2),
('SAIDA', 10, '2026-05-21 10:15:00', 'Venda cliente', 1, 3),
('SAIDA', 5, '2026-05-21 11:00:00', 'Consumo próprio', 3, 3),
('DEVOLUCAO', 2, '2026-05-22 14:30:00', 'Devolução cliente', 4, 2),
('AJUSTE', 5, '2026-05-22 15:00:00', 'Ajuste de inventário', 2, 1);
```

### 3️⃣ Validar

```sql
-- Ver tabelas
SHOW TABLES;

-- Ver dados
SELECT * FROM movimentacao;

-- Ver movimentações com detalhes
SELECT m.id, p.nome, m.tipo_movimentacao, m.quantidade, u.nome
FROM movimentacao m
JOIN produto p ON m.produto_id = p.id
JOIN usuario u ON m.usuario_id = u.id;
```

---

## 📊 Estrutura Básica

```
┌─────────┐      ┌───────────────────┐      ┌─────────┐
│USUARIO  │ 1:N  │  MOVIMENTACAO     │ N:1  │PRODUTO  │
├─────────┤      ├───────────────────┤      ├─────────┤
│id       │◄─────│usuario_id         │      │id       │
│email    │      │produto_id      ───┼─────►│nome     │
│nome     │      │tipo_movimentacao  │      │estoque  │
│senha    │      │quantidade         │      │data_val │
└─────────┘      │data_mov           │      └─────────┘
                 │observacao         │
                 │created_at         │
                 └───────────────────┘
```

---

## 🔍 Tipos de Movimentação

| Tipo | Descrição | Impacto |
|------|-----------|--------|
| ENTRADA | Compra/produção | Aumenta (+) |
| SAIDA | Venda/consumo | Diminui (-) |
| DEVOLUCAO | Devolvido cliente | Aumenta (+) |
| AJUSTE | Correção | Aumenta/Diminui |

---

## 📚 Documentação Completa

| Quando | Leia |
|--------|------|
| Entender o DER | `DER_MYSQL.md` |
| Ver diagrama | `DER_MYSQL_VISUAL.txt` |
| Executar SQL | `GUIA_SQL_MYSQL.md` |
| Usar em Java | `GUIA_IMPLEMENTACAO.md` |
| Visão geral | `SUMARIO_EXECUTIVO.md` |

---

## ✅ Pronto!

Seu banco de dados está criado e pronto para usar. 🎉

**Próximo**: Conectar com Spring Boot em `application.properties`

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/cafe
spring.datasource.username=root
spring.datasource.password=sua_senha
spring.jpa.hibernate.ddl-auto=validate
```

---

**Status**: ✅ Pronto para Usar  
**Data**: 22/05/2026

