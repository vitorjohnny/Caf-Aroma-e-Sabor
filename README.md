<div align="center">
  <h1>Cafe Aroma & Sabor</h1>
  <p><strong>Sistema de Gestao de Estoque Profissional</strong></p>
  <p>Desenvolvido com Java 21 e Spring Boot para o controle eficiente de inventario e movimentacoes.</p>
</div>

---

## Descricao do Projeto

O **Cafe Aroma & Sabor** e uma solucao robusta para gerenciamento de cafeterias, permitindo o controle rigoroso de insumos, produtos e usuarios. A aplicacao foca na usabilidade e na integridade dos dados, oferecendo alertas de estoque baixo e um historico detalhado de todas as operacoes realizadas no sistema.

---

## Funcionalidades Principais

- **Controle de Acesso** — Sistema de autenticacao seguro para gestao de usuarios (login, cadastro, logout)
- **Gestao de Inventario** — Cadastro tecnico de produtos com controle de validade, lote e preco
- **Monitoramento de Estoque** — Alertas visuais automaticos para produtos abaixo do estoque minimo
- **Fluxo de Movimentacao** — Registro completo de entradas, saidas, devolucoes e ajustes manuais
- **Dashboard Administrativo** — Visao analitica em tempo real sobre o status atual do estoque

---

## Tecnologias e Especificacoes

| Tecnologia | Especificacao |
|------------|--------------|
| Linguagem | Java 21 |
| Framework | Spring Boot 3.5.14 |
| Persistencia | Spring Data JPA / Hibernate |
| Banco de Dados | MySQL 8.x |
| Front-end | Thymeleaf (Server-side rendering) |
| Build | Maven |

---

## Como Executar

### Pre-requisitos

- JDK 21+
- MySQL Server 8.0+
- Maven

### Passos

```bash
# 1. Clone o repositorio
git clone https://github.com/vitorjohnny/Caf-Aroma-e-Sabor.git

# 2. Crie o banco de dados no MySQL
mysql -u root -p -e "CREATE DATABASE cafeteria;"

# 3. Configure as credenciais em src/main/resources/application.properties
spring.datasource.url=jdbc:mysql://localhost:3306/cafeteria
spring.datasource.username=seu_usuario
spring.datasource.password=sua_senha

# 4. Execute a aplicacao
mvn spring-boot:run
```

Acesse: [http://localhost:8080](http://localhost:8080)

---

## Estrutura do Projeto

```
cafe/
├── src/main/java/cafe/
│   ├── CafeApplication.java            # Ponto de entrada da aplicacao
│   ├── controller/
│   │   ├── AuthController.java         # Login, cadastro e logout
│   │   ├── HomeController.java         # Dashboard e estoque
│   │   └── ProdutoController.java      # CRUD de produtos
│   ├── model/
│   │   ├── Movimentacao.java           # Entidade de movimentacao
│   │   ├── Produto.java                # Entidade de produto
│   │   ├── TipoMovimentacao.java       # Enum (ENTRADA, SAIDA, DEVOLUCAO, AJUSTE)
│   │   └── Usuario.java                # Entidade de usuario
│   └── repository/
│       ├── MovimentacaoRepository.java
│       ├── ProdutoRepository.java
│       └── UsuarioRepository.java
├── src/main/resources/
│   ├── application.properties          # Configuracao do banco
│   ├── db_schema.sql                   # Script SQL completo
│   ├── static/css/style.css            # Estilos do sistema
│   └── templates/                      # Paginas HTML (Thymeleaf)
│       ├── index.html                  # Pagina de login
│       ├── welcome.html                # Landing page
│       ├── principal.html              # Dashboard
│       ├── estoque.html                # Gestao de estoque
│       ├── cadastro-usuario.html       # Cadastro de usuario
│       └── produto/
│           ├── cadastro.html           # Formulario de produto
│           └── lista.html              # Listagem de produtos
└── pom.xml                             # Dependencias Maven
```

---

## Modelo de Dados

```
+----------+         +----------------+         +----------+
| USUARIO  |1---N    | MOVIMENTACAO   |N---1    | PRODUTO  |
+----------+         +----------------+         +----------+
```

### Entidades

| Tabela | Campos principais |
|--------|-------------------|
| **USUARIO** | id (PK), email (UNIQUE), nome, senha |
| **PRODUTO** | id (PK), nome, descricao, categoria, unidadeMedida, preco, estoque, estoqueMinimo, lote, dataValidade |
| **MOVIMENTACAO** | id (PK), tipoMovimentacao, quantidade, dataMov, observacao, produto_id (FK), usuario_id (FK) |

### Tipos de Movimentacao

| Tipo | Descricao | Efeito no Estoque |
|------|-----------|-------------------|
| ENTRADA | Entrada de estoque (compra/producao) | Aumenta (+) |
| SAIDA | Saida de estoque (venda/consumo) | Diminui (-) |
| DEVOLUCAO | Devolucao de cliente | Aumenta (+) |
| AJUSTE | Ajuste de inventario | +/- conforme necessario |

---

## Endpoints da Aplicacao

| Metodo | Rota | Descricao |
|--------|------|-----------|
| GET | `/` | Landing page |
| GET | `/login` | Formulario de login |
| POST | `/login` | Autenticar usuario |
| GET | `/cadastro` | Formulario de cadastro |
| POST | `/cadastro` | Criar novo usuario |
| GET | `/logout` | Encerrar sessao |
| GET | `/principal` | Dashboard administrativo |
| GET | `/estoque` | Central de movimentacoes |
| GET | `/produtos` | Listagem de produtos |
| GET | `/produtos/novo` | Cadastro de novo produto |
| POST | `/produtos/salvar` | Salvar produto |
| GET | `/produtos/excluir/{id}` | Excluir produto |

---

## Script SQL

O arquivo `src/main/resources/db_schema.sql` contem o script completo para criar as tabelas e inserir dados de exemplo. O Hibernate tambem pode criar as tabelas automaticamente com `spring.jpa.hibernate.ddl-auto=update`.

---

## Diagramas DER

- `DER_MOVIMENTACAO.md` — DER focado na tabela de movimentacao
- `DER_PRODUTO_MOVIMENTACAO.md` — DER completo do sistema
- `DER_MERMAID.md` — Diagramas interativos em Mermaid
- `DER_MYSQL.md` — Documentacao MySQL detalhada

---

## Autor

**Vitor Johnny**

[GitHub](https://github.com/vitorjohnny)

---

## Licenca

Este projeto esta sob a licenca MIT.
