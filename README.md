# ☕ Café Aroma & Sabor - Sistema de Gestão de Estoque

Sistema web desenvolvido em **Java com Spring Boot** para gerenciamento de estoque de cafeteria. Permite cadastrar produtos, registrar movimentações (entrada/saída) e controlar usuários com login seguro.

---

## 🚀 Funcionalidades

- **Autenticação de Usuários** — Cadastro e login com sessão protegida
- **Cadastro de Produtos** — Nome, descrição, categoria, unidade de medida, preço, lote e data de validade
- **Gestão de Estoque** — Controle de quantidade e estoque mínimo com alertas visuais
- **Movimentações** — Registro de entrada, saída, devolução e ajuste de estoque
- **Dashboard** — Visão geral com total de produtos, alertas e últimas movimentações
- **Interface Responsiva** — Design adaptável para desktop e mobile

---

## 🛠️ Tecnologias

| Tecnologia | Versão |
|------------|--------|
| Java | 21 |
| Spring Boot | 3.5.14 |
| Spring Data JPA | Hibernate |
| Spring MVC + Thymeleaf | Templates HTML |
| MySQL | 8.x |
| Maven | Gerenciador de dependências |
| Lombok | Redução de boilerplate |

---

## 📦 Estrutura do Projeto

```
cafe/
├── src/main/java/cafe/
│   ├── CafeApplication.java           # Entrada da aplicação
│   ├── controller/
│   │   ├── AuthController.java        # Login, cadastro, logout
│   │   ├── HomeController.java        # Rotas principal e estoque
│   │   └── ProdutoController.java     # CRUD de produtos
│   ├── model/
│   │   ├── Movimentacao.java          # Entidade movimentação
│   │   ├── Produto.java               # Entidade produto
│   │   ├── TipoMovimentacao.java      # Enum (ENTRADA, SAIDA, ...)
│   │   └── Usuario.java               # Entidade usuário
│   └── repository/
│       ├── MovimentacaoRepository.java
│       ├── ProdutoRepository.java
│       └── UsuarioRepository.java
├── src/main/resources/
│   ├── application.properties         # Configuração do banco
│   ├── db_schema.sql                  # Script SQL completo
│   ├── static/css/style.css           # Estilos
│   └── templates/                     # Páginas HTML (Thymeleaf)
│       ├── index.html                 # Login
│       ├── welcome.html               # Landing page
│       ├── principal.html             # Dashboard
│       ├── estoque.html               # Gestão de estoque
│       ├── cadastro-usuario.html      # Cadastro de usuário
│       └── produto/
│           ├── cadastro.html          # Formulário de produto
│           └── lista.html             # Listagem de produtos
└── pom.xml                            # Dependências Maven
```

---

## 🗄️ Modelo de Dados

```
USUARIO (1) ──── (N) MOVIMENTACAO (N) ──── (1) PRODUTO
```

- **USUARIO**: id, email (único), nome, senha
- **PRODUTO**: id, nome, descricao, categoria, unidadeMedida, preco, estoque, estoqueMinimo, lote, dataValidade
- **MOVIMENTACAO**: id, tipoMovimentacao (ENTRADA|SAIDA|DEVOLUCAO|AJUSTE), quantidade, dataMov, observacao, produto_id (FK), usuario_id (FK)

---

## ⚙️ Como Executar

### Pré-requisitos

- Java 21+
- MySQL 8.x
- Maven

### Passos

```bash
# 1. Clone o repositório
git clone https://github.com/vitorjohnny/Caf-Aroma-e-Sabor.git

# 2. Configure o banco MySQL
#    Crie um banco chamado "cafeteria"

# 3. Ajuste o application.properties com suas credenciais
spring.datasource.url=jdbc:mysql://localhost:3306/cafeteria
spring.datasource.username=root
spring.datasource.password=sua_senha

# 4. Execute a aplicação
./mvnw spring-boot:run
```

Acesse: [http://localhost:8080](http://localhost:8080)

---

## 📄 Script SQL

O arquivo `db_schema.sql` contém o script completo para criar as tabelas e inserir dados de exemplo. Execute-o manualmente no MySQL Workbench ou deixe o Hibernate criar automaticamente (`ddl-auto=update`).

---

## 📊 Diagrama DER

Diagramas entidade-relacionamento disponíveis em:
- `DER_MYSQL.md` — DER completo em formato Markdown
- `DER_MERMAID.md` — Diagramas interativos (Mermaid)
- `DER_MOVIMENTACAO.md` — DER focado na tabela de movimentações
- `DER_MYSQL_VISUAL.txt` — Visualização em ASCII para terminal

---

## 📌 Rotas da API

| Método | Rota | Descrição |
|--------|------|-----------|
| GET | `/` | Landing page |
| GET | `/login` | Formulário de login |
| POST | `/login` | Autenticar usuário |
| GET | `/cadastro` | Formulário de cadastro |
| POST | `/cadastro` | Criar novo usuário |
| GET | `/logout` | Encerrar sessão |
| GET | `/principal` | Dashboard |
| GET | `/estoque` | Gestão de estoque |
| GET | `/produtos` | Listar produtos |
| GET | `/produtos/novo` | Formulário de novo produto |
| POST | `/produtos/salvar` | Salvar produto |
| GET | `/produtos/excluir/{id}` | Excluir produto |

---

## 👨‍🍳 Autor

**Vitor Johnny** — [GitHub](https://github.com/vitorjohnny)

---

## 📝 Licença

Este projeto está sob a licença MIT.
