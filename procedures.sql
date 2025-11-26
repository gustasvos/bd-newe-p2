USE db_newe_p2;

-- 1
-- Controlar onde cada usuário da empresa está trabalhando em um determinado dia (Remoto ou Presencial)
-- A procedure deve:
-- Trazer uma lista de registros ligando usuário_local com usuário (Inner join), mostrando nome, setor, role e o local (Remoto/Presencial) na data registrada.

DELIMITER //

CREATE PROCEDURE sp_lista_usuario_local(
    IN p_usuario_id INT,
    IN p_data DATE
)
BEGIN
    SELECT 
        u.id AS usuarioId,
        u.nome,
        u.setor,
        u.role,
        ul.id AS usuarioLocalId,
        ul.local,
        ul.data
    FROM usuario_local ul
    INNER JOIN usuario u ON u.id = ul.usuario_id
    WHERE (p_usuario_id IS NULL OR ul.usuario_id = p_usuario_id)
      AND (p_data IS NULL OR ul.data = p_data)
    ORDER BY ul.data DESC, u.nome;
END //

DELIMITER ;

-- todos os usuários em todas as datas
CALL sp_lista_usuario_local(NULL, NULL);

-- 2
-- Acompanhar todas as cotações realizadas por cada cliente, mostrando o nome, CNPJ e o status, valor e validade de cada cotação

DELIMITER //

CREATE PROCEDURE sp_lista_cotacoes_cliente(
    IN p_cliente_id INT
)
BEGIN
    SELECT 
        c.Id         AS clienteId,
        c.NomeFantasia,
        c.CNPJ,
        co.id        AS cotacaoId,
        co.status,
        co.valor_total,
        co.data_criacao,
        co.data_validade
    FROM cotacao co
    INNER JOIN cliente c ON co.id_cliente = c.Id
    WHERE (p_cliente_id IS NULL OR c.Id = p_cliente_id)
    ORDER BY c.NomeFantasia, co.data_criacao DESC;
END //

DELIMITER ;

CALL sp_lista_cotacoes_cliente(NULL);

-- 3
-- Facilitar o acompanhamento dos convidados de cada evento, listando os usuários, status (Pendente, Confirmado, Recusado) e o motivo (quando houver)

DELIMITER //

CREATE PROCEDURE sp_lista_convidados_evento(
    IN p_evento_id INT
)
BEGIN
    SELECT 
        e.id        AS eventoId,
        e.titulo    AS eventoTitulo,
        e.dataHora  AS eventoData,
        u.id        AS usuarioId,
        u.nome      AS usuarioNome,
        ec.status   AS conviteStatus,
        ec.motivo   AS motivoResposta,
        ec.criadoEm AS conviteCriadoEm
    FROM evento_convidado ec
    INNER JOIN evento e    ON ec.evento_id   = e.id
    INNER JOIN usuario u   ON ec.usuario_id  = u.id
    WHERE (p_evento_id IS NULL OR e.id = p_evento_id)
    ORDER BY e.dataHora DESC, ec.status, u.nome;
END //

DELIMITER ;

CALL sp_lista_convidados_evento(NULL);

-- 4
---Problema:
-- Permitir consultar o histórico de categorias de um cliente específico, mostrando quando o cliente mudou de categoria, qual categoria era e a observação associada.
-- LEFT JOIN permite registros com categoria ou id de cliente NULL, mantendo histórico mesmo em caso de alteração nas categorias ou exclusão de cliente

DELIMITER //

CREATE PROCEDURE sp_historico_categorias_cliente(
    IN p_cliente_id INT
)
BEGIN
    SELECT 
        c.Id AS clienteId,
        c.NomeFantasia,
        cc.categoria,
        rc.dataRegistro,
        rc.observacao
    FROM registro_cliente rc
    LEFT JOIN cliente_categoria cc ON rc.categoriaId = cc.id
    LEFT JOIN cliente c ON rc.clienteId = c.Id
    WHERE (p_cliente_id IS NULL OR c.Id = p_cliente_id)
    ORDER BY rc.dataRegistro DESC;
END //

DELIMITER ;

CALL sp_historico_categorias_cliente(NULL);

-- 5
-- Visualizar e consultar todos os agendamentos de cada cliente.

DELIMITER //

CREATE PROCEDURE sp_agendamentos_por_cliente(
    IN p_cliente_id INT
)
BEGIN
    SELECT
        c.Id             AS clienteId,
        c.NomeFantasia   AS clienteNome,
        c.CNPJ,
        a.id             AS agendamentoId,
        a.titulo         AS agendamentoTitulo,
        a.dataAgendamento,
        a.localizacao,
        a.descricao
    FROM agendamento_cliente a
    INNER JOIN cliente c ON a.clienteId = c.Id
    WHERE (p_cliente_id IS NULL OR c.Id = p_cliente_id)
    ORDER BY a.dataAgendamento DESC, c.NomeFantasia;
END //

DELIMITER ;

CALL sp_agendamentos_por_cliente(NULL);


-- 6
-- Permitir que o organizador de um evento rapidamente consulte todas as respostas dos participantes, incluindo a avaliação (nota), objetivo, comentários e nome do usuário.

DELIMITER //

CREATE PROCEDURE sp_respostas_evento(
    IN p_evento_id INT
)
BEGIN
    SELECT
        e.id AS eventoId,
        e.titulo AS eventoTitulo,
        e.dataHora AS eventoData,
        u.id AS usuarioId,
        u.nome AS usuarioNome,
        er.avaliacao,
        er.objetivo,
        er.comentarios
    FROM evento_resposta er
    INNER JOIN evento e ON er.evento_id = e.id
    INNER JOIN usuario u ON er.usuario_id = u.id
    WHERE (p_evento_id IS NULL OR e.id = p_evento_id)
    ORDER BY er.dataEvento DESC, u.nome;
END //

DELIMITER ;

CALL sp_respostas_evento(NULL);

