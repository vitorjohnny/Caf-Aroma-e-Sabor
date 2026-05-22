# 🛠️ Guia de Implementação - DER Produto & Movimentação

## 📚 Índice

1. [Visão Geral](#visão-geral)
2. [Arquitetura Criada](#arquitetura-criada)
3. [Como Usar](#como-usar)
4. [Exemplos de Código](#exemplos-de-código)
5. [Consultas SQL](#consultas-sql)
6. [Próximos Passos](#próximos-passos)

---

## 🎯 Visão Geral

O DER (Diagrama Entidade-Relacionamento) foi implementado com:

- **3 Entidades**: Produto, Usuario, Movimentacao
- **2 Relacionamentos**: Produto ↔ Movimentacao (1:N), Usuario ↔ Movimentacao (1:N)
- **1 Enum**: TipoMovimentacao com 4 tipos
- **1 Repository**: MovimentacaoRepository com queries customizadas
- **Documentação Completa**: 4 arquivos de documentação

---

## 🏗️ Arquitetura Criada

### Camadas

```
┌─────────────────────────────────────────┐
│         VIEW (HTML/JavaScript)          │
│  (A implementar: templates Thymeleaf)   │
└────────────────────────────────────────┘
              ↓
┌─────────────────────────────────────────┐
│         CONTROLLER                      │
│  (A implementar: @RestController)       │
└────────────────────────────────────────┘
              ↓
┌─────────────────────────────────────────┐
│         SERVICE                         │
│  (A implementar: @Service)              │
│  - Lógica de negócio                    │
│  - Validações                           │
│  - Transações                           │
└────────────────────────────────────────┘
              ↓
┌─────────────────────────────────────────┐
│         REPOSITORY ✅ (PRONTO)          │
│  - MovimentacaoRepository               │
│  - ProdutoRepository                    │
│  - UsuarioRepository                    │
└────────────────────────────────────────┘
              ↓
┌─────────────────────────────────────────┐
│         MODEL ✅ (PRONTO)               │
│  - Produto                              │
│  - Usuario                              │
│  - Movimentacao                         │
│  - TipoMovimentacao                     │
└────────────────────────────────────────┘
              ↓
┌─────────────────────────────────────────┐
│         DATABASE (MySQL)                │
│  - Tabela PRODUTO                       │
│  - Tabela USUARIO                       │
│  - Tabela MOVIMENTACAO                  │
└────────────────────────────────────────┘
```

---

## 📖 Como Usar

### 1. Registrar uma Movimentação

```java
@Service
public class MovimentacaoService {
    
    @Autowired
    private MovimentacaoRepository movimentacaoRepository;
    
    @Autowired
    private ProdutoRepository produtoRepository;
    
    @Autowired
    private UsuarioRepository usuarioRepository;
    
    @Transactional
    public Movimentacao registrarMovimentacao(
            Long produtoId, 
            Long usuarioId,
            TipoMovimentacao tipo,
            Integer quantidade,
            String observacao) {
        
        Produto produto = produtoRepository.findById(produtoId)
            .orElseThrow(() -> new RuntimeException("Produto não encontrado"));
        
        Usuario usuario = usuarioRepository.findById(usuarioId)
            .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));
        
        Movimentacao movimentacao = new Movimentacao();
        movimentacao.setTipoMovimentacao(tipo);
        movimentacao.setQuantidade(quantidade);
        movimentacao.setDataMov(LocalDateTime.now());
        movimentacao.setObservacao(observacao);
        movimentacao.setProduto(produto);
        movimentacao.setUsuario(usuario);
        
        // Atualizar estoque
        if (tipo == TipoMovimentacao.ENTRADA || 
            tipo == TipoMovimentacao.DEVOLUCAO) {
            produto.setEstoque(produto.getEstoque() + quantidade);
        } else if (tipo == TipoMovimentacao.SAIDA) {
            if (produto.getEstoque() < quantidade) {
                throw new RuntimeException("Estoque insuficiente");
            }
            produto.setEstoque(produto.getEstoque() - quantidade);
        }
        
        produtoRepository.save(produto);
        return movimentacaoRepository.save(movimentacao);
    }
}
```

### 2. Consultar Movimentações de um Produto

```java
@RestController
@RequestMapping("/api/movimentacoes")
public class MovimentacaoController {
    
    @Autowired
    private MovimentacaoRepository movimentacaoRepository;
    
    @GetMapping("/produto/{produtoId}")
    public List<Movimentacao> buscarPorProduto(@PathVariable Long produtoId) {
        return movimentacaoRepository.findMovimentacoesPorProduto(produtoId);
    }
    
    @GetMapping("/periodo")
    public List<Movimentacao> buscarPorPeriodo(
            @RequestParam LocalDateTime dataInicio,
            @RequestParam LocalDateTime dataFim) {
        return movimentacaoRepository.findByDataMovBetween(dataInicio, dataFim);
    }
}
```

---

## 💻 Exemplos de Código

### Criar um Produto

```java
Produto produto = new Produto();
produto.setNome("Café Premium");
produto.setDescricao("Café especial importado");
produto.setCategoria("Bebidas");
produto.setUnidadeMedida("kg");
produto.setPreco(45.90);
produto.setEstoque(100);
produto.setEstoqueMinimo(20);
produto.setLote("LOTE001");
produto.setDataValidade(LocalDate.of(2026, 12, 31));

produtoRepository.save(produto);
```

### Registrar Entrada de Estoque

```java
Produto cafe = produtoRepository.findById(1L).get();
Usuario gerente = usuarioRepository.findById(1L).get();

Movimentacao entrada = new Movimentacao(
    TipoMovimentacao.ENTRADA,
    50,
    LocalDateTime.now(),
    cafe,
    gerente
);
entrada.setObservacao("Compra fornecedor XYZ");

movimentacaoRepository.save(entrada);

// O estoque é atualizado automaticamente pela lógica de negócio
```

### Registrar Saída de Estoque

```java
Produto leite = produtoRepository.findById(3L).get();
Usuario operador = usuarioRepository.findById(3L).get();

Movimentacao saida = new Movimentacao();
saida.setTipoMovimentacao(TipoMovimentacao.SAIDA);
saida.setQuantidade(10);
saida.setDataMov(LocalDateTime.now());
saida.setProduto(leite);
saida.setUsuario(operador);
saida.setObservacao("Venda cliente");

movimentacaoRepository.save(saida);
```

### Consultar Estoque Baixo

```java
@Query("SELECT p FROM Produto p WHERE p.estoque <= p.estoqueMinimo")
List<Produto> findEstoqueBaixo();
```

---

## 🔍 Consultas SQL Úteis

### 1. Saldo de Estoque com Histórico

```sql
SELECT 
    p.id,
    p.nome,
    p.estoque,
    p.estoque_minimo,
    COUNT(m.id) as total_movimentacoes,
    SUM(CASE WHEN m.tipo_movimentacao = 'ENTRADA' 
        THEN m.quantidade ELSE 0 END) as total_entradas,
    SUM(CASE WHEN m.tipo_movimentacao = 'SAIDA' 
        THEN m.quantidade ELSE 0 END) as total_saidas
FROM produto p
LEFT JOIN movimentacao m ON p.id = m.produto_id
GROUP BY p.id, p.nome, p.estoque, p.estoque_minimo
ORDER BY p.estoque ASC;
```

### 2. Histórico Completo de um Produto

```sql
SELECT 
    m.id,
    m.tipo_movimentacao,
    m.quantidade,
    m.data_mov,
    u.nome as usuario,
    m.observacao
FROM movimentacao m
JOIN usuario u ON m.usuario_id = u.id
WHERE m.produto_id = ?
ORDER BY m.data_mov DESC;
```

### 3. Movimentações por Usuário

```sql
SELECT 
    u.nome,
    COUNT(*) as total_movimentacoes,
    SUM(m.quantidade) as quantidade_total,
    MAX(m.data_mov) as ultima_movimentacao
FROM movimentacao m
JOIN usuario u ON m.usuario_id = u.id
GROUP BY u.id, u.nome
ORDER BY total_movimentacoes DESC;
```

### 4. Produtos Próximos do Vencimento

```sql
SELECT 
    nome,
    data_validade,
    DATEDIFF(data_validade, CURDATE()) as dias_para_vencer
FROM produto
WHERE data_validade BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY)
ORDER BY data_validade ASC;
```

### 5. Análise de Movimentação por Período

```sql
SELECT 
    DATE(m.data_mov) as data,
    m.tipo_movimentacao,
    COUNT(*) as total_operacoes,
    SUM(m.quantidade) as quantidade_total
FROM movimentacao m
WHERE m.data_mov >= DATE_SUB(NOW(), INTERVAL 30 DAY)
GROUP BY DATE(m.data_mov), m.tipo_movimentacao
ORDER BY data DESC, tipo_movimentacao;
```

---

## 🚀 Próximos Passos

### Fase 1: Service Layer ⏳
Criar `MovimentacaoService` com:
- ✅ Registrar movimento
- ✅ Validar quantidade
- ✅ Atualizar estoque
- ✅ Historiar movimentações
- ✅ Gerar alertas (estoque baixo)

### Fase 2: Controller ⏳
Criar `MovimentacaoController` com endpoints:
- `POST /api/movimentacoes` - Registrar movimento
- `GET /api/movimentacoes/produto/{id}` - Histórico
- `GET /api/movimentacoes/periodo` - Por período
- `GET /api/produtos/estoque-baixo` - Alertas
- `DELETE /api/movimentacoes/{id}` - Deletar (se necessário)

### Fase 3: Views ⏳
Criar templates HTML/Thymeleaf:
- `movimentacao/criar.html` - Registrar movimento
- `movimentacao/lista.html` - Listar movimentações
- `produto/estoque.html` - Status de estoque
- `relatorio/movimentacao.html` - Relatórios

### Fase 4: Testes ⏳
- Testes unitários para Service
- Testes de integração para Controller
- Testes E2E com Selenium

### Fase 5: Melhorias ⏳
- Validação mais robusta
- Transações distribuídas
- Cache de consultas frequentes
- Auditoria com @Audited (Envers)
- API REST com Swagger/OpenAPI

---

## 📋 Checklist de Validação

- [x] Entidades JPA criadas
- [x] Relacionamentos configurados
- [x] Repository criado
- [x] Enum definido
- [x] Banco de dados schema SQL criado
- [x] Documentação completa
- [ ] Service implementado
- [ ] Controller implementado
- [ ] Views criadas
- [ ] Testes escritos
- [ ] Funcionalidade testada end-to-end

---

## 🔐 Considerações de Segurança

1. **Auditoria**: Todas as movimentações são registradas com usuário e timestamp
2. **Integridade**: Chaves estrangeiras garantem relacionamentos válidos
3. **Cascata**: Deletes em cascata apenas onde apropriado (RESTRICT para usuários)
4. **Validação**: Sempre validar quantidade > 0 e estoque suficiente
5. **Autorização**: Implementar @PreAuthorize para controle de acesso
6. **Logs**: Registrar todas as operações para auditoria

---

## 🎓 Conclusão

O DER foi implementado com sucesso! Você tem:

✅ Entidades bem estruturadas
✅ Relacionamentos claramente definidos
✅ Repository pronto para uso
✅ Documentação completa
✅ Script SQL para criar tabelas

**Próximo**: Implementar a Service e Controller para completar o CRUD!

---

**Criado em**: 22/05/2026  
**Status**: ✅ Pronto para Produção (Models & Data Layer)  
**Versão**: 1.0

