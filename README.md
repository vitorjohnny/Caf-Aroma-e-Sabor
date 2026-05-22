<div align="center">
  <h1>☕ Café Aroma & Sabor</h1>
  <p><strong>Sistema de Gestão de Estoque Profissional</strong></p>
  <p>Desenvolvido com Java 21 e Spring Boot para o controle eficiente de inventário e movimentações.</p>
</div>

---

## 📋 Descrição do Projeto

O **Café Aroma & Sabor** é uma solução robusta para gerenciamento de cafeterias, permitindo o controle rigoroso de insumos, produtos e usuários. A aplicação foca na usabilidade e na integridade dos dados, oferecendo alertas de estoque baixo e um histórico detalhado de todas as operações realizadas no sistema.

---

## ⚙️ Funcionalidades Principais

- **Controle de Acesso** — Sistema de autenticação seguro para gestão de usuários (login, cadastro, logout)
- **Gestão de Inventário** — Cadastro técnico de produtos com controle de validade, lote e preço
- **Monitoramento de Estoque** — Alertas visuais automáticos para produtos abaixo do estoque mínimo
- **Fluxo de Movimentação** — Registro completo de entradas, saídas, devoluções e ajustes manuais
- **Dashboard Administrativo** — Visão analítica em tempo real sobre o status atual do estoque

---

## 🛠️ Tecnologias e Especificações

| Tecnologia | Especificação |
|------------|--------------|
| Linguagem | Java 21 |
| Framework | Spring Boot 3.5.14 |
| Persistência | Spring Data JPA / Hibernate |
| Banco de Dados | MySQL 8.x |
| Front-end | Thymeleaf (Server-side rendering) |
| Build | Maven |

---

## 🚀 Como Executar

### Pré-requisitos

- JDK 21+
- MySQL Server 8.0+
- Maven

### Passos

```bash
# 1. Clone o repositório
git clone https://github.com/vitorjohnny/Caf-Aroma-e-Sabor.git

# 2. Crie o banco de dados no MySQL
mysql -u root -p -e "CREATE DATABASE cafeteria;"

# 3. Configure as credenciais em src/main/resources/application.properties
spring.datasource.url=jdbc:mysql://localhost:3306/cafeteria
spring.datasource.username=seu_usuario
spring.datasource.password=sua_senha

# 4. Execute a aplicação
mvn spring-boot:run
```

Acesse: [http://localhost:8080](http://localhost:8080)

---

## 📁 Estrutura do Projeto

```
cafe/
├── src/main/java/cafe/
│   ├── CafeApplication.java            # Ponto de entrada da aplicação
│   ├── controller/
│   │   ├── AuthController.java         # Login, cadastro e logout
│   │   ├── HomeController.java         # Dashboard e estoque
│   │   └── ProdutoController.java      # CRUD de produtos
│   ├── model/
│   │   ├── Movimentacao.java           # Entidade de movimentação
│   │   ├── Produto.java                # Entidade de produto
│   │   ├── TipoMovimentacao.java       # Enum (ENTRADA, SAIDA, DEVOLUCAO, AJUSTE)
│   │   └── Usuario.java                # Entidade de usuário
│   └── repository/
│       ├── MovimentacaoRepository.java
│       ├── ProdutoRepository.java
│       └── UsuarioRepository.java
├── src/main/resources/
│   ├── application.properties          # Configuração do banco
│   ├── db_schema.sql                   # Script SQL completo
│   ├── static/css/style.css            # Estilos do sistema
│   └── templates/                      # Páginas HTML (Thymeleaf)
│       ├── index.html                  # Página de login
│       ├── welcome.html                # Landing page
│       ├── principal.html              # Dashboard
│       ├── estoque.html                # Gestão de estoque
│       ├── cadastro-usuario.html       # Cadastro de usuário
│       └── produto/
│           ├── cadastro.html           # Formulário de produto
│           └── lista.html              # Listagem de produtos
└── pom.xml                             # Dependências Maven
```

---

## 🗄️ Modelo de Dados

```
┌──────────┐         ┌────────────────┐         ┌──────────┐
│ USUARIO  │1──N    │ MOVIMENTACAO   │N──1    │ PRODUTO  │
└──────────┘         └────────────────┘         └──────────┘
```

### Entidades

| Tabela | Campos principais |
|--------|-------------------|
| **USUARIO** | id (PK), email (UNIQUE), nome, senha |
| **PRODUTO** | id (PK), nome, descricao, categoria, unidadeMedida, preco, estoque, estoqueMinimo, lote, dataValidade |
| **MOVIMENTACAO** | id (PK), tipoMovimentacao, quantidade, dataMov, observacao, produto_id (FK), usuario_id (FK) |

### Tipos de Movimentação

| Tipo | Descrição | Efeito no Estoque |
|------|-----------|-------------------|
| ENTRADA | Entrada de estoque (compra/produção) | Aumenta (+) |
| SAIDA | Saída de estoque (venda/consumo) | Diminui (-) |
| DEVOLUCAO | Devolução de cliente | Aumenta (+) |
| AJUSTE | Ajuste de inventário | +/- conforme necessário |

---

## 🌐 Endpoints da Aplicação

| Método | Rota | Descrição |
|--------|------|-----------|
| GET | `/` | Landing page |
| GET | `/login` | Formulário de login |
| POST | `/login` | Autenticar usuário |
| GET | `/cadastro` | Formulário de cadastro |
| POST | `/cadastro` | Criar novo usuário |
| GET | `/logout` | Encerrar sessão |
| GET | `/principal` | Dashboard administrativo |
| GET | `/estoque` | Central de movimentações |
| GET | `/produtos` | Listagem de produtos |
| GET | `/produtos/novo` | Cadastro de novo produto |
| POST | `/produtos/salvar` | Salvar produto |
| GET | `/produtos/excluir/{id}` | Excluir produto |

---

## 📄 Script SQL

O arquivo `src/main/resources/db_schema.sql` contém o script completo para criar as tabelas e inserir dados de exemplo. O Hibernate também pode criar as tabelas automaticamente com `spring.jpa.hibernate.ddl-auto=update`.

---

## 📊 Diagramas DER

- `DER_MOVIMENTACAO.md` — DER focado na tabela de movimentação
- `DER_PRODUTO_MOVIMENTACAO.md` — DER completo do sistema
- `DER_MERMAID.md` — Diagramas interativos em Mermaid
- `DER_MYSQL.md` — Documentação MySQL detalhada

---

## 👨‍🍳 Autor

**Vitor Johnny**

[![GitHub](https://img.shields.io/badge/GitHub-vitorjohnny-181717?style=flat-square&logo=github)](https://github.com/vitorjohnny)

---

## 📝 Licença

Este projeto está sob a licença MIT.
