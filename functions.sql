-- 1
-- função que retorna os dias que faltam para expirar a cotação

DELIMITER $$

CREATE FUNCTION func_dias_para_expirar(idCotacao INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE diasRestantes INT;

    -- DATEDIFF: Return the number of days between two date values
    SELECT DATEDIFF(data_validade, CURDATE())
    INTO diasRestantes
    FROM cotacao
    WHERE id = idCotacao;

    RETURN diasRestantes;
END $$

DELIMITER ;

-- utilização
CREATE VIEW view_cotacoes_com_dias_para_expirar AS
SELECT 
    c.id,
    c.id_cliente,
    c.data_validade,
    func_dias_para_expirar(c.id) AS dias_para_expirar
FROM cotacao c;

SELECT * FROM view_cotacoes_com_dias_para_expirar;

-- 2
-- função que retorna o total de cotações existentes para um cliente específico

DELIMITER $$

CREATE FUNCTION func_total_cotacoes_cliente(clienteId INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;

    SELECT COUNT(*)
    INTO total
    FROM cotacao
    WHERE id_cliente = clienteId;

    RETURN total;
END $$

DELIMITER ;


-- utilização
CREATE VIEW view_total_cotacoes_cliente_id AS
SELECT 
    c.Id AS clienteId,
    c.NomeFantasia,
    func_total_cotacoes_cliente(c.Id) AS total_cotacoes
FROM cliente c;

SELECT * FROM view_total_cotacoes_cliente_id;

-- 3
-- função que calcula o valor médio das cotações de um cliente

DELIMITER $$

CREATE FUNCTION func_valor_medio_cotacoes(clienteId INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE media DECIMAL(10,2);

    SELECT AVG(valor_total)
    INTO media
    FROM cotacao
    WHERE id_cliente = clienteId;

    RETURN media;
END $$

DELIMITER ;

-- utilização
CREATE VIEW view_valor_medio_cotacoes AS
SELECT 
    c.Id AS clienteId,
    c.NomeFantasia,
    func_valor_medio_cotacoes(c.Id) AS media_valor
FROM cliente c;

SELECT * FROM view_valor_medio_cotacoes;

-- 4
-- função que retorna o total de clientes em cada categoria

DELIMITER $$

CREATE FUNCTION func_total_clientes_por_categoria(catId INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;

    SELECT COUNT(*)
    INTO total
    FROM registro_cliente
    WHERE categoriaId = catId;

    RETURN total;
END $$

DELIMITER ;

-- utilização
CREATE VIEW view_cliente_por_categoria AS
SELECT 
    cc.id,
    cc.categoria,
    func_total_clientes_por_categoria(cc.id) AS total_clientes
FROM cliente_categoria cc;

SELECT * FROM view_cliente_por_categoria;


-- 5
-- função que retorna os eventos pendentes de um usuario

DELIMITER $$

CREATE FUNCTION func_eventos_pendentes(p_usuarioId INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;

    SELECT COUNT(*)
    INTO total
    FROM evento_convidado
    WHERE usuario_id = p_usuarioId
      AND status = 'Pendente';

    RETURN total;
END $$

DELIMITER ;

-- utilização em toda a tabela
CREATE OR REPLACE VIEW view_eventos_pendentes_por_usuario AS
SELECT 
    u.id AS usuario_id,
    func_eventos_pendentes(u.id) AS total_eventos_pendentes
FROM usuario u
ORDER BY total_eventos_pendentes DESC;

SELECT * FROM view_eventos_pendentes_por_usuario;


-- 6
-- function que retorna o genero de um usuario

DELIMITER $$

CREATE FUNCTION func_genero_usuario(p_usuarioId INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE generoRetornado VARCHAR(20);

    SELECT genero
    INTO generoRetornado
    FROM usuario
    WHERE id = p_usuarioId;

    RETURN generoRetornado;
END $$

DELIMITER ;

-- utilização aplicada em toda a tabela usuario
CREATE OR REPLACE VIEW view_genero_usuarios AS
SELECT 
    u.id AS usuario_id,
    func_genero_usuario(u.id) AS genero
FROM usuario u;

SELECT * FROM view_genero_usuarios;
