# ☕ Café Aroma & Sabor — Descrição Completa do Sistema

## 📋 Visão Geral

O **Café Aroma & Sabor** é um sistema web de gestão de estoque desenvolvido para cafeterias e estabelecimentos do ramo alimentício. Seu objetivo principal é centralizar o controle de produtos, registrar movimentações de estoque e gerenciar usuários em uma plataforma intuitiva e responsiva.

Construído com **Java 21** e **Spring Boot 3.5.14**, o sistema segue o padrão MVC (Model-View-Controller) com templates Thymeleaf no front-end e JPA/Hibernate para persistência de dados em **MySQL**.

---

## 🎯 Objetivos do Sistema

1. **Controlar o estoque** de produtos de cafeteria com cadastro detalhado
2. **Registrar movimentações** (entrada, saída, devolução e ajuste) com rastreabilidade
3. **Gerenciar usuários** com autenticação por email e senha
4. **Alertar sobre estoque baixo** e produtos próximos ao vencimento
5. **Fornecer dashboard** com visão geral do negócio

---

## 👥 Público-Alvo

- Donos e gerentes de cafeterias
- Operadores de estoque e almoxarifado
- Pequenos e médios estabelecimentos do ramo alimentício

---

## 🧩 Arquitetura do Sistema

### Camadas

```
[Cliente (Browser)] → [Controller (Spring MVC)] → [Service/Camada de negócio]
                                                          ↓
                                              [Repository (JPA)]
                                                          ↓
                                              [Entity (Model)] → [MySQL]
```

### Fluxo de uma Movimentação

1. Usuário faz login no sistema
2. Navega até a página de estoque
3. Seleciona o produto, tipo de movimentação e quantidade
4. Sistema valida os dados e registra a movimentação
5. Estoque do produto é atualizado automaticamente
6. Movimentação fica registrada para auditoria com data, hora e usuário responsável

---

## 🗄️ Estrutura do Banco de Dados

### Tabelas

| Tabela | Descrição | Linhas estimadas |
|--------|-----------|-----------------|
| `usuario` | Usuários do sistema (login) | Dezenas |
| `produto` | Produtos do estoque | Centenas |
| `movimentacao` | Registro de movimentações | Milhares |

### Relacionamentos

- **PRODUTO** (1) ──── (N) **MOVIMENTACAO**: Um produto pode ter várias movimentações
- **USUARIO** (1) ──── (N) **MOVIMENTACAO**: Um usuário pode realizar várias movimentações

### Regras de Negócio

- **DELETE CASCADE**: Se um produto for excluído, todas as suas movimentações são removidas
- **DELETE RESTRICT**: Um usuário com movimentações registradas não pode ser excluído (proteção de auditoria)
- **Estoque mínimo**: Alerta visual quando a quantidade atinge ou ultrapassa o limite definido

---

## 👨‍💻 Funcionalidades Detalhadas

### 1. Autenticação (`AuthController.java`)
- **Login**: Validação de email e senha contra o banco de dados
- **Cadastro**: Criação de novo usuário com verificação de email duplicado
- **Logout**: Invalidação da sessão HTTP
- **Proteção**: Verificação de sessão em todas as rotas protegidas

### 2. CRUD de Produtos (`ProdutoController.java`)
- **Listagem**: Tabela com todos os produtos cadastrados
- **Cadastro**: Formulário com campos para nome, descrição, categoria, unidade de medida, preço, estoque mínimo, lote e data de validade
- **Exclusão**: Remoção de produto com ID

### 3. Dashboard (`HomeController.java`)
- **Estatísticas**: Total de produtos cadastrados
- **Nome do usuário logado**: Exibido no header
- **Atalhos**: Acesso rápido às funcionalidades principais

### 4. Gestão de Estoque
- **Visualização**: Tabela com estoque atual e status (OK / Estoque baixo)
- **Formulário de movimentação**: Seleção de produto, tipo, quantidade, data e responsável
- **Alertas**: Destaque visual para itens com estoque abaixo do mínimo

---

## 🌐 Interface do Usuário

### Páginas

| Página | Arquivo | Descrição |
|--------|---------|-----------|
| Landing Page | `welcome.html` | Página inicial com apresentação do sistema |
| Login | `index.html` | Formulário de autenticação |
| Cadastro de Usuário | `cadastro-usuario.html` | Criação de nova conta |
| Dashboard | `principal.html` | Visão geral com estatísticas |
| Gestão de Estoque | `estoque.html` | Movimentações e tabela de produtos |
| Cadastro de Produto | `produto/cadastro.html` | Formulário de produto |
| Lista de Produtos | `produto/lista.html` | Tabela completa de produtos |

### Design

- Tema **café** com cores marrons (#6f4e37) e tons terrosos
- **Sidebar** fixa com navegação principal
- **Responsivo**: Adaptável para desktop (sidebar) e mobile (layout empilhado)
- **Animações**: Fade In e background flutuante para experiência agradável
- **Landing page** com imagem de fundo de café e overlay escuro

---

## 💻 Tecnologias Utilizadas

| Tecnologia | Função | Motivo da Escolha |
|------------|--------|-------------------|
| **Java 21** | Linguagem principal | Maturidade, performance e segurança |
| **Spring Boot 3.5.14** | Framework web | Produtividade, configuração automática |
| **Spring MVC** | Padrão arquitetural | Separação clara entre camadas |
| **Spring Data JPA (Hibernate)** | ORM / Persistência | Mapeamento objeto-relacional automático |
| **Thymeleaf** | Template engine | Integração nativa com Spring MVC |
| **MySQL** | Banco de dados | Confiabilidade, amplamente utilizado |
| **Maven** | Gerenciamento de dependências | Padrão no ecossistema Java |
| **Lombok** | Redução de código boilerplate | Produtividade no desenvolvimento |
| **CSS3** | Estilização | Design responsivo e animações |

---

## 🔧 Configuração do Ambiente

### application.properties

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/cafeteria
spring.datasource.username=root
spring.datasource.password=Senai@403

spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true

spring.thymeleaf.cache=false
```

### Dependências (pom.xml)

- `spring-boot-starter-data-jpa` — Persistência com JPA/Hibernate
- `spring-boot-starter-thymeleaf` — Templates HTML
- `spring-boot-starter-web` — MVC e servidor embutido (Tomcat)
- `mysql-connector-j` — Driver MySQL
- `lombok` — Getters/Setters automáticos
- `spring-boot-starter-test` — Testes unitários

---

## 📁 Estrutura de Arquivos (Completa)

```
cafe/
├── pom.xml
├── mvnw / mvnw.cmd
├── .gitignore / .gitattributes
├── README.md                           ← Este README
├── DESCRICAO.md                        ← Descrição detalhada
├── DER_MOVIMENTACAO.md                 ← DER focado em movimentação
├── DER_PRODUTO_MOVIMENTACAO.md         ← DER completo
├── DER_MERMAID.md                      ← DER em Mermaid
├── DER_MYSQL.md                        ← DER MySQL
├── DER_MYSQL_VISUAL.txt                ← DER visual ASCII
├── DER_VISUAL.txt                      ← DER visual alternativo
├── RESUMO_DER.md / ESPECIFICACAO_DER.md
├── GUIA_IMPLEMENTACAO.md / GUIA_SQL_MYSQL.md
├── QUICK_START.md
├── README_DOCUMENTACAO.md / SUMARIO_EXECUTIVO.md
├── Projeto 2/                          ← Protótipos estáticos
└── src/
    ├── main/
    │   ├── java/cafe/
    │   │   ├── CafeApplication.java
    │   │   ├── controller/
    │   │   │   ├── AuthController.java
    │   │   │   ├── HomeController.java
    │   │   │   └── ProdutoController.java
    │   │   ├── model/
    │   │   │   ├── Movimentacao.java
    │   │   │   ├── Produto.java
    │   │   │   ├── TipoMovimentacao.java
    │   │   │   └── Usuario.java
    │   │   └── repository/
    │   │       ├── MovimentacaoRepository.java
    │   │       ├── ProdutoRepository.java
    │   │       └── UsuarioRepository.java
    │   └── resources/
    │       ├── application.properties
    │       ├── db_schema.sql
    │       ├── static/css/style.css
    │       └── templates/
    │           ├── index.html
    │           ├── welcome.html
    │           ├── home.html
    │           ├── principal.html
    │           ├── estoque.html
    │           ├── cadastro-usuario.html
    │           └── produto/
    │               ├── cadastro.html
    │               └── lista.html
    └── test/java/cafe/
        └── CafeApplicationTests.java
```

---

## 🧪 Testes

O projeto inclui um teste de contexto (`CafeApplicationTests.java`) que verifica se a aplicação Spring Boot inicializa corretamente.

Para executar:
```bash
./mvnw test
```

---

## 🚀 Como Implantar

### Produção

```bash
# Build do projeto
./mvnw clean package -DskipTests

# O JAR será gerado em target/cafe-0.0.1-SNAPSHOT.jar
java -jar target/cafe-0.0.1-SNAPSHOT.jar
```

### Desenvolvimento

```bash
./mvnw spring-boot:run
# Acessar: http://localhost:8080
```

---

## 🔒 Segurança

- **Senhas**: Armazenadas diretamente no banco (melhorias futuras: hash com BCrypt)
- **Sessão**: Controle via `HttpSession` com verificação em todas as rotas
- **Proteção de rotas**: Usuário não logado é redirecionado ao login
- **Validação de unicidade**: Email duplicado é verificado no cadastro

---

## 🎨 Identidade Visual

- **Paleta**: Marrom (#6f4e37), Bege (#f2efe9), Tons escuros (#4d3c30)
- **Tipografia**: Inter (sans-serif moderna)
- **Background**: Padrão geométrico sutil com gradientes
- **Ícones**: Emojis nativos para badges e indicadores

---

## 📈 Melhorias Futuras

- [ ] Criptografia de senhas com BCrypt
- [ ] Relatórios exportáveis (PDF/Excel)
- [ ] Filtros e busca avançada de movimentações
- [ ] Notificações por email para estoque baixo
- [ ] Histórico completo de alterações em produtos
- [ ] API REST para integração com outros sistemas
- [ ] Testes de integração e unitários mais abrangentes
- [ ] Paginação nas listagens
- [ ] Upload de imagens para produtos
- [ ] Controle de múltiplos almoxarifados

---

## 📅 Cronograma do Projeto

| Etapa | Status | Entregas |
|-------|--------|----------|
| Modelagem de dados | ✅ Concluído | DER, SQL, Entidades JPA |
| Back-end (Spring Boot) | ✅ Concluído | Controllers, Repositories |
| Front-end (Thymeleaf) | ✅ Concluído | Templates, CSS |
| Banco de dados | ✅ Concluído | db_schema.sql, Hibernate |
| Documentação | ✅ Concluído | README, DERs, Guias |

---

## 👨‍🍳 Autor

**Vitor Johnny** — Desenvolvedor Full Stack

[![GitHub](https://img.shields.io/badge/GitHub-vitorjohnny-181717?style=flat-square&logo=github)](https://github.com/vitorjohnny)

---

## 📄 Licença

Distribuído sob a licença MIT. Consulte o arquivo `LICENSE` para mais informações.

---

*Projeto desenvolvido como parte do curso técnico em Desenvolvimento de Sistemas.*
