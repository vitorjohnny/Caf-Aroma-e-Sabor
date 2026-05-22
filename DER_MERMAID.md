# DER em Formato Mermaid

## Diagrama ER

```mermaid
erDiagram
    USUARIO ||--o{ MOVIMENTACAO : "registra"
    PRODUTO ||--o{ MOVIMENTACAO : "contém"

    USUARIO {
        bigint id PK
        string email UK
        string nome
        string senha
        timestamp created_at
    }

    PRODUTO {
        bigint id PK
        string nome
        string descricao
        string categoria
        string unidade_medida
        decimal preco
        int estoque
        int estoque_minimo
        string lote
        date data_validade
        timestamp created_at
        timestamp updated_at
    }

    MOVIMENTACAO {
        bigint id PK
        string tipo_movimentacao
        int quantidade
        datetime data_mov
        string observacao
        bigint produto_id FK
        bigint usuario_id FK
        timestamp created_at
    }
```

---

## Diagrama de Fluxo

```mermaid
flowchart TD
    A["Usuário acessa o Sistema"] --> B["Vai para Controle de Estoque"]
    B --> C["Clica em Nova Movimentação"]
    C --> D["Seleciona Tipo de Movimento"]
    D --> E{Tipo?}
    E -->|ENTRADA| F["Aumenta Estoque"]
    E -->|SAIDA| G["Diminui Estoque"]
    E -->|DEVOLUCAO| H["Aumenta Estoque"]
    E -->|AJUSTE| I["Ajusta Conforme Necessário"]
    F --> J["Registra em MOVIMENTACAO"]
    G --> J
    H --> J
    I --> J
    J --> K["Atualiza Campo ESTOQUE em PRODUTO"]
    K --> L["Sucesso!"]
    L --> M["Movimentação Registrada para Auditoria"]
```

---

## Diagrama de Classes

```mermaid
classDiagram
    class Produto {
        -Long id
        -String nome
        -String descricao
        -String categoria
        -String unidadeMedida
        -Double preco
        -Integer estoque
        -Integer estoqueMinimo
        -String lote
        -LocalDate dataValidade
        -List~Movimentacao~ movimentacoes
        +getId()
        +getNome()
        +setNome()
        +getEstoque()
        +setEstoque()
        +getMovimentacoes()
        +setMovimentacoes()
    }

    class Usuario {
        -Long id
        -String email
        -String nome
        -String senha
        +getId()
        +getEmail()
        +setEmail()
        +getNome()
        +setNome()
    }

    class Movimentacao {
        -Long id
        -TipoMovimentacao tipoMovimentacao
        -Integer quantidade
        -LocalDateTime dataMov
        -String observacao
        -Produto produto
        -Usuario usuario
        +getId()
        +getTipoMovimentacao()
        +setTipoMovimentacao()
        +getQuantidade()
        +setQuantidade()
        +getDataMov()
        +setDataMov()
        +getProduto()
        +setProduto()
        +getUsuario()
        +setUsuario()
    }

    class TipoMovimentacao {
        ENTRADA
        SAIDA
        DEVOLUCAO
        AJUSTE
        -String descricao
        +getDescricao()
    }

    class MovimentacaoRepository {
        +findByProdutoId()
        +findByProduto()
        +findByDataMovBetween()
        +findMovimentacoesPorProduto()
    }

    Produto "1" -- "0..*" Movimentacao : contém
    Usuario "1" -- "0..*" Movimentacao : registra
    Movimentacao "1" -- "1" TipoMovimentacao : usa
    MovimentacaoRepository -- Movimentacao : gerencia
```

---

## Sequência: Registrar Movimentação

```mermaid
sequenceDiagram
    actor User as Usuário
    participant View as View (HTML)
    participant Controller as Controller
    participant Service as MovimentacaoService
    participant Repo as Repository
    participant DB as Database

    User->>View: Preenche formulário
    View->>Controller: POST /movimentacoes
    Controller->>Service: registrarMovimentacao()
    Service->>Repo: findProductById()
    Repo->>DB: SELECT * FROM produto
    DB-->>Repo: Produto encontrado
    Repo-->>Service: Produto
    Service->>Repo: findUsuarioById()
    Repo->>DB: SELECT * FROM usuario
    DB-->>Repo: Usuário encontrado
    Repo-->>Service: Usuário
    Service->>Service: Validar quantidade
    Service->>Service: Atualizar estoque
    Service->>Repo: save(movimentacao)
    Repo->>DB: INSERT INTO movimentacao
    DB-->>Repo: OK
    Repo->>DB: UPDATE produto SET estoque=...
    DB-->>Repo: OK
    Repo-->>Service: Movimentacao salva
    Service-->>Controller: OK
    Controller-->>View: Redirect to sucesso
    View-->>User: Mensagem de sucesso
```

---

## Diagrama de Banco de Dados

```mermaid
graph LR
    A[(Database<br/>café)] -->|contém| B[USUARIO]
    A -->|contém| C[PRODUTO]
    A -->|contém| D[MOVIMENTACAO]
    
    B -->|1..n| D
    C -->|1..n| D
    
    style A fill:#ff9999
    style B fill:#99ccff
    style C fill:#99ff99
    style D fill:#ffff99
```

---

## Estados de Movimentação

```mermaid
stateDiagram-v2
    [*] --> SelecionarTipo
    SelecionarTipo --> SelecionarProduto
    SelecionarProduto --> DefinirQuantidade
    DefinirQuantidade --> AdicionarObservacao
    AdicionarObservacao --> Validar
    Validar --> ValidacaoOK: Dados válidos
    Validar --> ValidacaoErro: Dados inválidos
    ValidacaoErro --> SelecionarTipo
    ValidacaoOK --> RegistrarMovimentacao
    RegistrarMovimentacao --> AtualizarEstoque
    AtualizarEstoque --> Sucesso
    Sucesso --> [*]
```

---

## Ciclo de Vida de um Produto

```mermaid
graph TD
    A["Cadastro de Produto"] --> B["ENTRADA<br/>Recebimento"]
    B --> C["ESTOQUE<br/>Em Armazém"]
    C --> D{"Tipo de Operação"}
    D -->|Venda| E["SAIDA<br/>Saída do Estoque"]
    D -->|Devolução| F["DEVOLUCAO<br/>Retorno"]
    D -->|Ajuste| G["AJUSTE<br/>Correção"]
    E --> H["Histórico Completo<br/>na MOVIMENTACAO"]
    F --> H
    G --> H
    C --> I["Controle de Validade"]
    I --> J["Alerta se Vencimento Próximo"]
    
    style A fill:#ffdddd
    style B fill:#ffff99
    style C fill:#99ff99
    style E fill:#ff9999
    style F fill:#ffcc99
    style G fill:#cc99ff
    style H fill:#99ccff
    style I fill:#ffddcc
    style J fill:#ff9999
```

---

## Relacionamentos JSON (REST API)

```mermaid
graph TD
    A["GET /api/produtos"] --> B["Lista de Produtos"]
    B --> C["GET /api/movimentacoes/produto/1"]
    C --> D["Movimentações do Produto"]
    
    E["POST /api/movimentacoes"] --> F["Registra Nova Movimentação"]
    F --> G["Atualiza Estoque Produto"]
    G --> H["Sucesso"]
    
    I["GET /api/movimentacoes/periodo?inicio=...&fim=..."] --> J["Movimentações por Período"]
    
    style A fill:#99ccff
    style C fill:#99ccff
    style E fill:#99ff99
    style I fill:#99ccff
    style H fill:#99ff99
```

---

Este documento utiliza a sintaxe Mermaid para criar diagramas. Você pode:

1. **Visualizar no GitHub** - Renderiza automaticamente
2. **Copiar para Notion** - Funciona em muitas plataformas
3. **Exportar como imagem** - Use mermaid.live

Para editar: https://mermaid.live

