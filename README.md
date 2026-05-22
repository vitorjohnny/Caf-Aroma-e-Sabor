<div align="center">
  <h1>Café Aroma & Sabor</h1>
  <p><strong>Sistema de Gestão de Estoque Profissional</strong></p>
  <p>Desenvolvido com Java 21 e Spring Boot para o controle eficiente de inventário e movimentações.</p>
</div>

<hr>

## Descrição do Projeto

O sistema Café Aroma & Sabor é uma solução robusta para gerenciamento de cafeterias, permitindo o controle rigoroso de insumos, produtos e usuários. A aplicação foca na usabilidade e na integridade dos dados, oferecendo alertas de estoque baixo e um histórico detalhado de todas as operações realizadas no sistema.

<hr>

## Funcionalidades Principais

*   **Controle de Acesso:** Sistema de autenticação seguro para gestão de usuários.
*   **Gestão de Inventário:** Cadastro técnico de produtos com controle de validade e lote.
*   **Monitoramento de Estoque:** Alertas visuais automáticos para produtos abaixo do estoque mínimo.
*   **Fluxo de Movimentação:** Registro completo de entradas, saídas, devoluções e ajustes manuais.
*   **Dashboard Administrativo:** Visão analítica em tempo real sobre o status atual do estoque.

<hr>

## Tecnologias e Especificações

<table width="100%">
  <tr>
    <td width="50%"><strong>Linguagem</strong></td>
    <td width="50%">Java 21</td>
  </tr>
  <tr>
    <td><strong>Framework Base</strong></td>
    <td>Spring Boot 3.5.14</td>
  </tr>
  <tr>
    <td><strong>Persistência de Dados</strong></td>
    <td>Spring Data JPA / Hibernate</td>
  </tr>
  <tr>
    <td><strong>Banco de Dados</strong></td>
    <td>MySQL 8.x</td>
  </tr>
  <tr>
    <td><strong>Front-end Engine</strong></td>
    <td>Thymeleaf (Server-side rendering)</td>
  </tr>
  <tr>
    <td><strong>Gerenciamento de Dependências</strong></td>
    <td>Maven</td>
  </tr>
</table>

<hr>

## Estrutura de Diretórios

```text
src/main/java/cafe/
├── controller/    # Gerenciamento de rotas e requisições
├── model/         # Definição de entidades e regras de negócio
├── repository/    # Interfaces de comunicação com o banco de dados
└── resources/     # Configurações, scripts SQL e templates HTML
