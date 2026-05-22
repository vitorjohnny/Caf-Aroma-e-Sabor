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
```

<br>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Configuração e Instalação - Café Aroma e Sabor</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif;
            line-height: 1.6;
            color: #24292e;
            max-width: 800px;
            margin: 20px auto;
            padding: 0 20px;
        }
        h1, h2, h3 {
            border-bottom: 1px solid #eaecef;
            padding-bottom: 0.3em;
        }
        code {
            background-color: rgba(27, 31, 35, 0.05);
            border-radius: 3px;
            padding: 0.2em 0.4em;
            font-family: "SFMono-Regular", Consolas, "Liberation Mono", Menlo, monospace;
        }
        pre {
            background-color: #f6f8fa;
            border-radius: 3px;
            padding: 16px;
            overflow: auto;
            line-height: 1.45;
        }
        pre code {
            background-color: transparent;
            padding: 0;
        }
        table {
            border-collapse: collapse;
            width: 100%;
            margin: 20px 0;
        }
        table th, table td {
            border: 1px solid #dfe2e5;
            padding: 6px 13px;
        }
        table tr:nth-child(even) {
            background-color: #f6f8fa;
        }
        .footer {
            text-align: center;
            margin-top: 50px;
            font-size: 0.9em;
            color: #6a737d;
        }
        hr {
            height: 0.25em;
            padding: 0;
            margin: 24px 0;
            background-color: #e1e4e8;
            border: 0;
        }
    </style>
</head>
<body>

    <section>
        <h2>Configuração e Instalação</h2>
        
        <h3>Pré-requisitos</h3>
        <ul>
            <li>JDK 21 ou superior</li>
            <li>MySQL Server 8.0+</li>
            <li>Maven</li>
        </ul>

        <h3>Passos para Execução</h3>
        
        <h4>Clonagem do Repositório</h4>
        <pre><code>git clone https://github.com/vitorjohnny/Caf-Aroma-e-Sabor.git</code></pre>

        <h4>Configuração do Banco de Dados</h4>
        <p>Crie um banco de dados chamado <code>cafeteria</code> no seu servidor MySQL.</p>

        <h4>Ajuste de Propriedades</h4>
        <p>Configure o arquivo <code>src/main/resources/application.properties</code> com suas credenciais locais:</p>
<pre><code>spring.datasource.url=jdbc:mysql://localhost:3306/cafeteria
spring.datasource.username=seu_usuario
spring.datasource.password=sua_senha</code></pre>

        <h4>Inicialização</h4>
        <pre><code>mvn spring-boot:run</code></pre>
    </section>

    <hr>

    <section>
        <h2>Endpoints da Aplicação</h2>
        <table>
            <thead>
                <tr>
                    <th>Método</th>
                    <th>Rota</th>
                    <th>Descrição</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>GET</td>
                    <td><code>/login</code></td>
                    <td>Acesso ao sistema</td>
                </tr>
                <tr>
                    <td>GET</td>
                    <td><code>/principal</code></td>
                    <td>Dashboard de indicadores</td>
                </tr>
                <tr>
                    <td>GET</td>
                    <td><code>/produtos</code></td>
                    <td>Listagem geral de itens</td>
                </tr>
                <tr>
                    <td>POST</td>
                    <td><code>/produtos/salvar</code></td>
                    <td>Persistência de novos produtos</td>
                </tr>
                <tr>
                    <td>GET</td>
                    <td><code>/estoque</code></td>
                    <td>Central de movimentações</td>
                </tr>
            </tbody>
        </table>
    </section>

    <hr>

    <footer>
        <h3>Autor</h3>
        <p><strong>Vitor Johnny</strong><br>
        <a href="https://github.com/vitorjohnny" target="_blank">Perfil no GitHub</a></p>
        
        <div class="footer">
            <hr>
            <p>Este projeto está sob a licença MIT.</p>
        </div>
    </footer>

</body>
</html>
