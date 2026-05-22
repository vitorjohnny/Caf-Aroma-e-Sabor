# DER - Movimentação (Estoque)
## Diagrama Entidade-Relacionamento Focado

```
╔══════════════════════════════════════════════════════════════╗
║               TABELA: MOVIMENTACAO (Central)                ║
╠══════════════════════════════════════════════════════════════╣
║  #  │ Coluna             │ Tipo          │ Constraints      ║
╠══════════════════════════════════════════════════════════════╣
║  1  │ id                 │ BIGINT        │ PK, AUTO_INCREMENT║
║  2  │ tipo_movimentacao  │ VARCHAR(50)   │ NOT NULL, INDEX   ║
║  3  │ quantidade         │ INT           │ NOT NULL          ║
║  4  │ data_mov           │ DATETIME      │ NOT NULL, INDEX   ║
║  5  │ observacao         │ VARCHAR(500)  │ NULLABLE          ║
║  6  │ produto_id         │ BIGINT        │ NOT NULL, FK, IDX ║
║  7  │ usuario_id         │ BIGINT        │ NOT NULL, FK, IDX ║
║  8  │ created_at         │ TIMESTAMP     │ DEFAULT NOW       ║
╠══════════════════════════════════════════════════════════════╣
║  INDEX COMPOSTO: idx_movimentacao_produto_data              ║
║  (produto_id, data_mov)                                     ║
╠══════════════════════════════════════════════════════════════╣
║  FK: fk_movimentacao_produto  → produto(id)                 ║
║  ON DELETE CASCADE | ON UPDATE CASCADE                      ║
╠══════════════════════════════════════════════════════════════╣
║  FK: fk_movimentacao_usuario  → usuario(id)                 ║
║  ON DELETE RESTRICT | ON UPDATE CASCADE                     ║
╚══════════════════════════════════════════════════════════════╝

                          │
                          │
        ┌─────────────────┼─────────────────┐
        │                 │                 │
        │ N:1             │                 │ N:1
        │ FK: produto_id  │                 │ FK: usuario_id
        ▼                 │                 ▼

┌──────────────────────────────┐  ┌──────────────────────────────┐
│        PRODUTO               │  │        USUARIO               │
├──────────────────────────────┤  ├──────────────────────────────┤
│ PK: id            BIGINT     │  │ PK: id            BIGINT     │
│ nome              VARCHAR255 │  │ email             VARCHAR255 │
│ descricao         VARCHAR500 │  │ nome              VARCHAR255 │
│ categoria         VARCHAR100 │  │ senha             VARCHAR255 │
│ unidade_medida    VARCHAR50  │  │ created_at        TIMESTAMP   │
│ preco             DECIMAL10,2│  └──────────────────────────────┘
│ estoque           INT        │
│ estoque_minimo    INT        │
│ lote              VARCHAR100 │
│ data_validade     DATE       │
│ created_at        TIMESTAMP  │
│ updated_at        TIMESTAMP  │
└──────────────────────────────┘
```

---

## Script SQL Completo (para copiar e colar no MySQL)

```sql
-- ============================================
-- SCRIPT PARA CRIAR SOMENTE A MOVIMENTACAO
-- Execute no banco cafeteria
-- ============================================

-- Verificar se as tabelas PRODUTO e USUARIO existem
-- (São pré-requisitos para a FK)

CREATE TABLE IF NOT EXISTS movimentacao (
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

---

## Se as tabelas PRODUTO e USUARIO não existirem, execute primeiro:

```sql
CREATE TABLE IF NOT EXISTS usuario (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) UNIQUE NOT NULL,
    nome VARCHAR(255) NOT NULL,
    senha VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS produto (
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

---

## Cardinalidades

| Origem | Relação | Destino | Tipo |
|--------|---------|---------|------|
| PRODUTO | 1 ─── N | MOVIMENTACAO | OneToMany |
| USUARIO | 1 ─── N | MOVIMENTACAO | OneToMany |
| MOVIMENTACAO | N ─── 1 | PRODUTO | ManyToOne |
| MOVIMENTACAO | N ─── 1 | USUARIO | ManyToOne |

---

## Mapeamento JPA (Java)

```java
// Movimentacao.java
@Entity
@Table(name = "movimentacao")
public class Movimentacao {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TipoMovimentacao tipoMovimentacao;

    @Column(nullable = false)
    private Integer quantidade;

    @Column(nullable = false)
    private LocalDateTime dataMov;

    private String observacao;

    @ManyToOne
    @JoinColumn(name = "produto_id", nullable = false)
    private Produto produto;

    @ManyToOne
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;
}
```

---

## Valores do Enum TipoMovimentacao

| Valor | Descrição | Efeito no Estoque |
|-------|-----------|-------------------|
| ENTRADA | Entrada de estoque | + aumenta |
| SAIDA | Saída de estoque | - diminui |
| DEVOLUCAO | Devolução de cliente | + aumenta |
| AJUSTE | Ajuste de inventário | +/- conforme necessário |

---

## Troubleshooting - Por que a tabela não aparece no Reverse Engineering?

1. **Execute o script SQL diretamente** no MySQL Workbench antes de fazer Reverse Engineering
2. **Verifique o banco correto**: `USE cafeteria;`
3. **Confirme as tabelas existentes**: `SHOW TABLES;`
4. **Verifique a estrutura**: `DESCRIBE movimentacao;`
5. **Se estiver usando JPA/Hibernate**: O `ddl-auto=update` no `application.properties` já cria a tabela automaticamente ao iniciar a aplicação

```
spring.jpa.hibernate.ddl-auto=update
```

Basta rodar a aplicação Spring Boot que a tabela `movimentacao` será criada automaticamente pelo Hibernate com base na entidade `Movimentacao.java`.
