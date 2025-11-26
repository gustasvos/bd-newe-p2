USE db_newe_p2;

-- 1 
-- Quando cria usuario, cria um valor pra ele em usuario_local

DELIMITER $$

CREATE TRIGGER trigger_insere_usuario_local
AFTER INSERT ON usuario
FOR EACH ROW
BEGIN
    INSERT INTO usuario_local (usuario_id, local, data)
    VALUES (NEW.id, 'Presencial', CURDATE());
END //

DELIMITER ;

-- 2 
-- Após atualizar evento_convidado, insere valor em evento_resposta, com motivo caso a resposta seja RECUSADO

DELIMITER $$

CREATE TRIGGER trigger_update_evento_convidado
AFTER UPDATE ON evento_convidado
FOR EACH ROW
BEGIN
    -- Se status foi alterado para 'Confirmado', cria uma resposta padrão em evento_resposta
    IF NEW.status = 'Confirmado' AND OLD.status <> 'Confirmado' THEN
        INSERT INTO evento_resposta (
            evento_id,
            usuario_id,
            tituloEvento,
            dataEvento,
            objetivo,
            avaliacao,
            comentarios
        )
        SELECT
            e.id,
            NEW.usuario_id,
            e.titulo,
            e.dataHora,
            'Participar do evento',
            FLOOR(RAND() * 5) + 1,
            'Resposta automática criada pelo sistema'
        FROM evento e
        WHERE e.id = NEW.evento_id;
    END IF;

    -- Se status foi alterado para 'Recusado', define um motivo padrão
    IF NEW.status = 'Recusado' AND OLD.status <> 'Recusado' AND (NEW.motivo IS NULL OR NEW.motivo = '') THEN
        UPDATE evento_convidado
        SET motivo = 'Motivo não informado'
        WHERE id = NEW.id;
    END IF;
END //

DELIMITER ;

-- 3
-- Após inserir em evento, insere em evento_convidado com o id do evento criado e convida o usuario de id = 1

DELIMITER $$

CREATE TRIGGER trigger_insert_evento_e_convidado
AFTER INSERT ON evento
FOR EACH ROW
BEGIN
    INSERT INTO evento_convidado (
        usuario_id,
        evento_id,
        status,
        criadoEm
    ) VALUES (
        1,
        NEW.id,
        'Pendente',
        NOW()
    );
END $$

DELIMITER ;


-- 4
-- Após atualizar registro_cliente para categoria "Follow Up", este trigger cria uma cotação com o cliente envolvido

DELIMITER $$

CREATE TRIGGER trigger_update_registro_cliente
AFTER UPDATE ON registro_cliente
FOR EACH ROW
BEGIN
    IF NEW.categoriaId = 6 AND OLD.categoriaId <> 6 THEN

        INSERT INTO cotacao (
            id_cliente,
            data_criacao,
            data_validade,
            status,
            valor_total
        ) VALUES (
            NEW.clienteId,
            NOW(),
            DATE_ADD(CURDATE(), INTERVAL 30 DAY),
            'Pendente',
            0.00
        );

    END IF;
END $$

DELIMITER ;


-- 5
-- Após a criação de uma cotação, marca uma reuniao automatica em agendamento_cliente

DELIMITER $$

CREATE TRIGGER trigger_insert_cotacao_e_reuniao
AFTER INSERT ON cotacao
FOR EACH ROW
BEGIN
    INSERT INTO agendamento_cliente (
        clienteId,
        titulo,
        dataAgendamento,
        descricao,
        localizacao
    ) VALUES (
        NEW.id_cliente,
        'Reunião de Acompanhamento da Cotação',
        DATE_ADD(NEW.data_criacao, INTERVAL 3 DAY),
        'Reunião automática agendada após a criação da cotação.',
        'A confirmar'
    );
END $$

DELIMITER ;

-- 6
-- Valida a cotação, não permite valor total negativo e data inválida

DELIMITER $$

CREATE TRIGGER trigger_valida_valor_cotacao
BEFORE INSERT ON cotacao
FOR EACH ROW
BEGIN
    IF NEW.valor_total < 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Valor total da cotação não pode ser negativo.';
    END IF;

    IF NEW.data_validade < DATE(NEW.data_criacao) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Data de validade não pode ser menor que a data de criação.';
    END IF;
END $$

