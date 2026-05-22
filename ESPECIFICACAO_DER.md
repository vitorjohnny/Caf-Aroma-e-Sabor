# Especificação do DER - Produto e Movimentação

## 📐 Arquitetura do Banco de Dados

### Entidades Principais

#### 1️⃣ PRODUTO
**Propósito**: Armazenar dados dos produtos do café

**Campos**:
- `id` (PK): Identificador único
- `nome`: Nome do produto
- `descricao`: Descrição detalhada
- `categoria`: Categoria (Bebidas, Alimentos, Ingredientes, etc)
- `unidadeMedida`: Unidade de medida (kg, L, unidades)
- `preco`: Preço unitário
- `estoque`: Quantidade atual em estoque
- `estoqueMinimo`: Limite mínimo de estoque
- `lote`: Número do lote para rastreamento
- `dataValidade`: Data de validade do produto

**Constraints**:
- `nome`: NOT NULL
- Email único: UNIQUE

---

#### 2️⃣ USUARIO
**Propósito**: Armazenar dados dos usuários que fazem operações no sistema

**Campos**:
- `id` (PK): Identificador único
- `email`: Email único do usuário
- `nome`: Nome completo do usuário
- `senha`: Senha criptografada

**Constraints**:
- `email`: NOT NULL, UNIQUE
- `nome`: NOT NULL
- `senha`: NOT NULL

---

#### 3️⃣ MOVIMENTACAO
**Propósito**: Registrar TODAS as movimentações de estoque para auditoria

**Campos**:
- `id` (PK): Identificador único
- `tipoMovimentacao`: Enum (ENTRADA, SAIDA, DEVOLUCAO, AJUSTE)
- `quantidade`: Quantidade movimentada
- `dataMov`: Data e hora da operação
- `observacao`: Observações opcionais
- `produto_id` (FK): Referência ao produto
- `usuario_id` (FK): Referência ao usuário que fez a operação

**Constraints**:
- `tipoMovimentacao`: NOT NULL
- `quantidade`: NOT NULL, > 0
- `dataMov`: NOT NULL
- `produto_id`: NOT NULL, FK → PRODUTO(id)
- `usuario_id`: NOT NULL, FK → USUARIO(id)

---

## 🔗 Relacionamentos

### PRODUTO ← OneToMany → MOVIMENTACAO
```
Um PRODUTO pode ter MUITAS MOVIMENTAÇÕEs
Uma MOVIMENTACAO pertence a UM PRODUTO

Cardinalidade: 1:N
Tipo JPA: @OneToMany em Produto, @ManyToOne em Movimentacao
Cascade: DELETE (quando produto é deletado, suas movimentações são deletadas)
Orphan Removal: true
```

### USUARIO ← OneToMany → MOVIMENTACAO
```
Um USUARIO pode fazer MUITAS MOVIMENTAÇÕEs
Uma MOVIMENTACAO é feita por UM USUARIO

Cardinalidade: 1:N
Tipo JPA: @ManyToOne em Movimentacao
Cascade: RESTRICT (não permite deletar usuário se tiver movimentações)
```

---

## 📊 Diagrama ER Textual

```
┌──────────────────┐
│     USUARIO      │
├──────────────────┤
│ id (PK)          │
│ email (UNIQUE)   │
│ nome             │
│ senha            │
└──────────────────┘
         │ 
         │ 1:N (usuário fez muitas movimentações)
         │
         │◄────────────────┐
         │                 │
         │          ┌──────────────────────┐
         │          │  MOVIMENTACAO        │
         │          ├──────────────────────┤
         │          │ id (PK)              │
         │          │ tipoMovimentacao     │
         │          │ quantidade           │
         │          │ dataMov              │
         │          │ observacao           │
         │          │ produto_id (FK)   ───┼─────────┐
         │          │ usuario_id (FK)   ───┘         │
         │          └──────────────────────┘          │
         │                                            │
         └────────────────────────────────────────────┤
                                                       │ N:1 (muitas movimentações 
                                                       │      para um produto)
                                                       │
                                              ┌────────────────────────┐
                                              │     PRODUTO            │
                                              ├────────────────────────┤
                                              │ id (PK)                │
                                              │ nome                   │
                                              │ descricao              │
                                              │ categoria              │
                                              │ unidadeMedida          │
                                              │ preco                  │
                                              │ estoque                │
                                              │ estoqueMinimo          │
                                              │ lote                   │
                                              │ dataValidade           │
                                              │ movimentacoes (List)   │
                                              └────────────────────────┘
```

---

## 🛠️ Operações Possíveis

### No Produto
- ✅ Cadastrar novo produto
- ✅ Atualizar informações do produto
- ✅ Visualizar estoque atual
- ✅ Consultar histórico de movimentações
- ✅ Deletar produto (com cascata de movimentações)

### Em Movimentação
- ✅ Registrar entrada de estoque
- ✅ Registrar saída de estoque
- ✅ Registrar devolução
- ✅ Registrar ajuste de inventário
- ✅ Consultar movimentações por período
- ✅ Consultar movimentações por produto
- ✅ Consultar movimentações por usuário
- ✅ Gerar relatórios de movimento

---

## 📈 Exemplo de Fluxo de Negócio

```
1. USUÁRIO 'admin' faz LOGIN
   ↓
2. USUÁRIO vai para Controle de Estoque
   ↓
3. USUÁRIO registra ENTRADA de Café Premium (50 kg)
   → INSERT em MOVIMENTACAO (tipo=ENTRADA, qtd=50, usuario_id=1, produto_id=1)
   → UPDATE PRODUTO set estoque = estoque + 50 where id = 1
   ↓
4. GERENTE consulta histórico do Café Premium
   → SELECT * FROM MOVIMENTACAO where produto_id = 1 ORDER BY data_mov DESC
   ↓
5. SISTEMA gera RELATÓRIO com todas as movimentações
```

---

## 🔐 Integridade Referencial

| Tabela | Campo | Referencia | Ação DELETE | Ação UPDATE |
|--------|-------|-----------|------------|------------|
| MOVIMENTACAO | produto_id | PRODUTO.id | CASCADE | CASCADE |
| MOVIMENTACAO | usuario_id | USUARIO.id | RESTRICT | CASCADE |

**RESTRICT**: Impede deletar usuário se tiver movimentações (mais seguro para auditoria)
**CASCADE**: Deleta todas as movimentações quando um produto é deletado

---

## 📑 Índices para Performance

```sql
-- Busca rápida por produto
INDEX idx_produto_id (produto_id)

-- Busca rápida por usuário
INDEX idx_usuario_id (usuario_id)

-- Busca rápida por data
INDEX idx_data_mov (data_mov)

-- Busca rápida por tipo
INDEX idx_tipo_movimentacao (tipo_movimentacao)

-- Busca mais comum: movimento de um produto
INDEX idx_movimentacao_produto_data (produto_id, data_mov)
```

---

## 🎯 Tipos de Movimentação Suportados

| Tipo | Descrição | Afeta Estoque |
|------|-----------|---------------|
| ENTRADA | Entrada de estoque (compra, produção) | ➕ Aumenta |
| SAIDA | Saída de estoque (venda, consumo) | ➖ Diminui |
| DEVOLUCAO | Devolução de cliente | ➕ Aumenta |
| AJUSTE | Ajuste de inventário | ➕/➖ Varia |

---

## 📝 Consultas SQL Comuns

### Saldo de estoque por produto
```sql
SELECT id, nome, estoque, estoque_minimo FROM produto ORDER BY estoque ASC;
```

### Histórico completo de um produto
```sql
SELECT m.*, u.nome FROM movimentacao m 
JOIN usuario u ON m.usuario_id = u.id
WHERE m.produto_id = ? ORDER BY m.data_mov DESC;
```

### Movimentações em um período
```sql
SELECT * FROM movimentacao 
WHERE data_mov BETWEEN ? AND ? 
ORDER BY data_mov DESC;
```

### Produtos com estoque baixo
```sql
SELECT * FROM produto WHERE estoque <= estoque_minimo ORDER BY estoque ASC;
```

---

## 🔄 Ciclo de Vida da Movimentação

```
PLANEJAMENTO
    ↓
REGISTRO DA MOVIMENTAÇÃO
    ├─ Usuário seleciona tipo (ENTRADA/SAIDA/DEVOLUCAO/AJUSTE)
    ├─ Usuário seleciona Produto
    ├─ Usuário informa quantidade
    └─ Sistema registra em MOVIMENTACAO
    ↓
ATUALIZAÇÃO DE ESTOQUE (pode ser automática ou manual)
    └─ Atualiza campo ESTOQUE em PRODUTO
    ↓
AUDITORIA
    └─ Registro permanece em MOVIMENTACAO para auditoria
    ↓
CONSULTAS E RELATÓRIOS
    └─ Usar MOVIMENTACAO para análises
```

---

## ✅ Checklist de Implementação

- [x] Entidade PRODUTO criada
- [x] Entidade USUARIO criada  
- [x] Entidade MOVIMENTACAO criada
- [x] Enum TipoMovimentacao criado
- [x] Relacionamento OneToMany PRODUTO ↔ MOVIMENTACAO
- [x] Relacionamento ManyToOne MOVIMENTACAO ↔ USUARIO
- [x] Repository MovimentacaoRepository criado
- [x] Índices criados para performance
- [x] DER documentado
- [] Serviços criados (Service Layer)
- [ ] Controller criado
- [ ] Testes unitários criados
- [ ] Telas HTML criadas

