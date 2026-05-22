-- ============================================
-- DER: PRODUTO e MOVIMENTAÇÃO
-- Banco de Dados: Café
-- ============================================

-- Tabela: USUARIO
-- Descrição: Armazena informações dos usuários do sistema
CREATE TABLE usuario (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) UNIQUE NOT NULL,
    nome VARCHAR(255) NOT NULL,
    senha VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabela: PRODUTO
-- Descrição: Armazena informações dos produtos
CREATE TABLE produto (
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

-- Tabela: MOVIMENTACAO
-- Descrição: Registra todas as movimentações de estoque
-- Relacionamentos:
--   - N:1 com PRODUTO (muitas movimentações para um produto)
--   - N:1 com USUARIO (muitas movimentações para um usuário)
CREATE TABLE movimentacao (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    tipo_movimentacao VARCHAR(50) NOT NULL,
    quantidade INT NOT NULL,
    data_mov DATETIME NOT NULL,
    observacao VARCHAR(500),
    produto_id BIGINT NOT NULL,
    usuario_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- Chaves Estrangeiras
    CONSTRAINT fk_movimentacao_produto FOREIGN KEY (produto_id)
        REFERENCES produto(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_movimentacao_usuario FOREIGN KEY (usuario_id)
        REFERENCES usuario(id) ON DELETE RESTRICT ON UPDATE CASCADE,

    -- Índices para melhor performance
    INDEX idx_produto_id (produto_id),
    INDEX idx_usuario_id (usuario_id),
    INDEX idx_data_mov (data_mov),
    INDEX idx_tipo_movimentacao (tipo_movimentacao),
    INDEX idx_movimentacao_produto_data (produto_id, data_mov)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- SCRIPTS DE INSERÇÃO PARA TESTES
-- ============================================

-- Inserir usuários
INSERT INTO usuario (email, nome, senha) VALUES
('admin@cafe.com', 'Administrador', 'senha_hash_aqui'),
('gerente@cafe.com', 'Gerente de Estoque', 'senha_hash_aqui'),
('operador@cafe.com', 'Operador de Estoque', 'senha_hash_aqui');

-- Inserir produtos
INSERT INTO produto (nome, descricao, categoria, unidade_medida, preco, estoque, estoque_minimo, lote, data_validade)
VALUES
('Café Premium', 'Café especial importado', 'Bebidas', 'kg', 45.90, 100, 20, 'LOTE001', '2026-12-31'),
('Açúcar Cristal', 'Açúcar cristal refinado', 'Ingredientes', 'kg', 3.50, 500, 100, 'LOTE002', '2027-06-30'),
('Leite Integral', 'Leite integral fresco', 'Bebidas', 'L', 5.00, 200, 50, 'LOTE003', '2026-06-15'),
('Biscoito Amanteigado', 'Biscoito amanteigado crocante', 'Alimentos', 'un', 12.50, 150, 30, 'LOTE004', '2027-03-20');

-- Inserir movimentações de exemplo
INSERT INTO movimentacao (tipo_movimentacao, quantidade, data_mov, observacao, produto_id, usuario_id)
VALUES
('ENTRADA', 50, '2026-05-20 08:00:00', 'Compra fornecedor', 1, 1),
('ENTRADA', 200, '2026-05-20 09:30:00', 'Compra fornecedor', 2, 2),
('SAIDA', 10, '2026-05-21 10:15:00', 'Venda cliente', 1, 3),
('SAIDA', 5, '2026-05-21 11:00:00', 'Consumo próprio', 3, 3),
('DEVOLUCAO', 2, '2026-05-22 14:30:00', 'Devolução cliente', 4, 2),
('AJUSTE', 5, '2026-05-22 15:00:00', 'Ajuste de inventário', 2, 1);

-- ============================================
-- CONSULTAS ÚTEIS
-- ============================================

-- Consultar movimentações com nome do produto e usuário
SELECT
    m.id,
    p.nome as produto,
    m.tipo_movimentacao,
    m.quantidade,
    m.data_mov,
    u.nome as usuario,
    m.observacao
FROM movimentacao m
JOIN produto p ON m.produto_id = p.id
JOIN usuario u ON m.usuario_id = u.id
ORDER BY m.data_mov DESC;

-- Consultar estoque atual por produto
SELECT
    id,
    nome,
    estoque,
    estoque_minimo,
    categoria,
    data_validade,
    CASE
        WHEN estoque <= estoque_minimo THEN 'CRÍTICO'
        WHEN estoque < estoque_minimo * 2 THEN 'BAIXO'
        ELSE 'OK'
    END as status_estoque
FROM produto
ORDER BY estoque ASC;

-- Histórico de movimentações por produto
SELECT
    p.nome,
    m.tipo_movimentacao,
    m.quantidade,
    m.data_mov,
    u.nome as usuario
FROM movimentacao m
JOIN produto p ON m.produto_id = p.id
JOIN usuario u ON m.usuario_id = u.id
WHERE p.id = 1
ORDER BY m.data_mov DESC;

-- Movimentações por período
SELECT
    DATE(m.data_mov) as data,
    COUNT(*) as total_movimentacoes,
    SUM(m.quantidade) as quantidade_total
FROM movimentacao m
WHERE m.data_mov BETWEEN '2026-05-01' AND '2026-05-31'
GROUP BY DATE(m.data_mov)
ORDER BY data DESC;

-- Produtos com estoque baixo
SELECT
    nome,
    estoque,
    estoque_minimo,
    (estoque_minimo - estoque) as falta
FROM produto
WHERE estoque <= estoque_minimo
ORDER BY falta DESC;

