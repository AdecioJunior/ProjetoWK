-- Criar banco de dados (se não existir)
CREATE DATABASE IF NOT EXISTS wk_pedidos;
USE wk_pedidos;

-- Tabela de clientes
CREATE TABLE IF NOT EXISTS clientes (
  codigo INT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  cidade VARCHAR(50),
  uf CHAR(2)
);

-- Tabela de produtos
CREATE TABLE IF NOT EXISTS produtos (
  codigo INT PRIMARY KEY,
  descricao VARCHAR(100) NOT NULL,
  preco_venda DECIMAL(10,2) NOT NULL
);

-- Tabela de pedidos (dados gerais)
CREATE TABLE IF NOT EXISTS pedidos (
  numero_pedido INT PRIMARY KEY,
  data_emissao DATE NOT NULL,
  codigo_cliente INT NOT NULL,
  valor_total DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (codigo_cliente) REFERENCES clientes(codigo)
);

-- Tabela de itens do pedido
CREATE TABLE IF NOT EXISTS pedido_itens (
  id INT AUTO_INCREMENT PRIMARY KEY,
  numero_pedido INT NOT NULL,
  codigo_produto INT NOT NULL,
  quantidade INT NOT NULL,
  valor_unitario DECIMAL(10,2) NOT NULL,
  valor_total DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (numero_pedido) REFERENCES pedidos(numero_pedido),
  FOREIGN KEY (codigo_produto) REFERENCES produtos(codigo)
);

-- Índices adicionais (usando IF NOT EXISTS apenas onde suportado)
-- Infelizmente, MySQL não permite CREATE INDEX IF NOT EXISTS nativamente.
-- Para evitar erro em execuções repetidas, você pode antes remover manualmente ou testar via script.

-- Usar banco
USE wk_pedidos;

-- Limpar dados com respeito às FKs (filhos → pais)
SET SQL_SAFE_UPDATES = 0;

DELETE FROM pedido_itens;
DELETE FROM pedidos;
DELETE FROM produtos;
DELETE FROM clientes;

SET SQL_SAFE_UPDATES = 1;

-- Inserir clientes
INSERT INTO clientes (codigo, nome, cidade, uf) VALUES
(1, 'Ana Costa', 'Florianópolis', 'SC'),
(2, 'Bruno Lima', 'Curitiba', 'PR'),
(3, 'Carlos Dias', 'São Paulo', 'SP'),
(4, 'Daniela Souza', 'Joinville', 'SC'),
(5, 'Eduardo Moraes', 'Porto Alegre', 'RS'),
(6, 'Fernanda Alves', 'Rio de Janeiro', 'RJ'),
(7, 'Gabriel Teixeira', 'Belo Horizonte', 'MG'),
(8, 'Helena Rocha', 'Cuiabá', 'MT'),
(9, 'Igor Mendes', 'Salvador', 'BA'),
(10, 'Julia Freitas', 'Campinas', 'SP'),
(11, 'Kaio Martins', 'Maceió', 'AL'),
(12, 'Larissa Cruz', 'Belém', 'PA'),
(13, 'Marcos Pontes', 'Vitória', 'ES'),
(14, 'Natalia Borges', 'Recife', 'PE'),
(15, 'Otávio Ramos', 'Natal', 'RN'),
(16, 'Patrícia Melo', 'Aracaju', 'SE'),
(17, 'Quésia Silva', 'São Luís', 'MA'),
(18, 'Rodrigo Farias', 'Manaus', 'AM'),
(19, 'Sandra Dias', 'Boa Vista', 'RR'),
(20, 'Thiago Lopes', 'Palmas', 'TO');

-- Inserir produtos
INSERT INTO produtos (codigo, descricao, preco_venda) VALUES
(1, 'Notebook', 3200.00),
(2, 'Mouse', 80.00),
(3, 'Teclado', 150.00),
(4, 'Monitor 24"', 900.00),
(5, 'HD Externo', 350.00),
(6, 'Cabo HDMI', 45.00),
(7, 'Pendrive 64GB', 70.00),
(8, 'Fonte ATX', 200.00),
(9, 'Memória RAM 8GB', 230.00),
(10, 'SSD 240GB', 280.00),
(11, 'Webcam', 150.00),
(12, 'Caixa de som', 120.00),
(13, 'Microfone USB', 190.00),
(14, 'Headset Gamer', 350.00),
(15, 'Mousepad', 35.00),
(16, 'Impressora', 850.00),
(17, 'Scanner', 600.00),
(18, 'Roteador Wi-Fi', 140.00),
(19, 'Notebook Gamer', 7500.00),
(20, 'Switch Ethernet', 210.00);

-- Reiniciar contador de auto_increment
ALTER TABLE pedido_itens AUTO_INCREMENT = 1;
