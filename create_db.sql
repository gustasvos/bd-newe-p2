-- Created by Redgate Data Modeler (https://datamodeler.redgate-platform.com)
-- Last modification date: 2025-11-24 02:17:27.256

CREATE DATABASE IF NOT EXISTS db_newe_p2;
USE db_newe_p2;

-- tables
-- Table: agendamento_cliente
CREATE TABLE agendamento_cliente (
    id int  NOT NULL AUTO_INCREMENT,
    clienteId int  NOT NULL,
    titulo varchar(50)  NOT NULL,
    dataAgendamento datetime  NOT NULL,
    descricao varchar(500)  NOT NULL,
    localizacao varchar(300)  NOT NULL,
    CONSTRAINT agendamento_cliente_pk PRIMARY KEY (id)
);

-- Table: cliente
CREATE TABLE cliente (
    Id int  NOT NULL AUTO_INCREMENT,
    CNPJ varchar(14)  NOT NULL,
    NomeFantasia varchar(255)  NOT NULL,
    PrazoFaturamento datetime  NOT NULL,
    ContatoResponsavel varchar(255)  NOT NULL,
    EmailResponsavel varchar(255)  NOT NULL,
    CNAE varchar(10)  NOT NULL,
    descricaoCNAE varchar(255)  NOT NULL,
    colaboradorId int  NOT NULL,
    CONSTRAINT cliente_pk PRIMARY KEY (Id)
);

-- Table: cliente_categoria
CREATE TABLE cliente_categoria (
    id int  NOT NULL AUTO_INCREMENT,
    categoria Enum('Prospect','Inicial','Potencial','Manutencao','Em Negociacao','Follow Up')  NOT NULL,
    CONSTRAINT cliente_categoria_pk PRIMARY KEY (id)
);

-- Table: cotacao
CREATE TABLE cotacao (
    id int  NOT NULL AUTO_INCREMENT,
    id_cliente int  NOT NULL,
    data_criacao datetime  NOT NULL,
    data_validade date  NOT NULL,
    status varchar(50)  NOT NULL,
    valor_total decimal(10,2)  NOT NULL,
    detalhes_frete Text  NOT NULL,
    motivo_recusa Text  NOT NULL,
    caminho_arquivo_pdf varchar(255)  NULL,
    observacoes_internas Text  NOT NULL,
    detalhes_internas Text  NOT NULL,
    CONSTRAINT cotacao_pk PRIMARY KEY (id)
);

-- Table: evento
CREATE TABLE evento (
    id int  NOT NULL AUTO_INCREMENT,
    titulo varchar(255)  NOT NULL,
    descricao Text  NOT NULL,
    dataHora date  NOT NULL,
    localizacao varchar(255)  NOT NULL,
    CONSTRAINT evento_pk PRIMARY KEY (id)
);

-- Table: evento_convidado
CREATE TABLE evento_convidado (
    id int  NOT NULL AUTO_INCREMENT,
    usuario_id int  NOT NULL,
    evento_id int  NOT NULL,
    status Enum('Pendente','Confirmado','Recusado')  NOT NULL,
    motivo varchar(1024)  NOT NULL,
    criadoEm datetime  NOT NULL,
    CONSTRAINT evento_convidado_pk PRIMARY KEY (id)
);

-- Table: evento_resposta
CREATE TABLE evento_resposta (
    id int  NOT NULL AUTO_INCREMENT,
    evento_id int  NOT NULL,
    usuario_id int  NOT NULL,
    tituloEvento varchar(255)  NOT NULL,
    dataEvento date  NOT NULL,
    objetivo varchar(255)  NOT NULL,
    avaliacao int  NOT NULL,
    comentarios varchar(255)  NOT NULL,
    CONSTRAINT evento_resposta_pk PRIMARY KEY (id)
);

-- Table: registro_cliente
CREATE TABLE registro_cliente (
    id int  NOT NULL AUTO_INCREMENT,
    categoriaId int  NOT NULL,
    clienteId int  NOT NULL,
    dataRegistro date  NOT NULL,
    observacao varchar(500)  NOT NULL,
    CONSTRAINT registro_cliente_pk PRIMARY KEY (id)
);

-- Table: tarefas
CREATE TABLE tarefas (
    id int  NOT NULL AUTO_INCREMENT,
    cliente_Id int  NOT NULL,
    vendedor_id int  NOT NULL,
    titulo varchar(255)  NOT NULL,
    data datetime  NOT NULL,
    status Enum('Pendente','Concluida','Cancelada')  NOT NULL,
    tipo Enum('Ligacao','Email','Visita','Reuniao','Outro')  NOT NULL,
    descricao Text  NOT NULL,
    CONSTRAINT tarefas_pk PRIMARY KEY (id)
);

-- Table: usuario
CREATE TABLE usuario (
    id int  NOT NULL AUTO_INCREMENT,
    nome varchar(255)  NOT NULL,
    cpf varchar(11)  NOT NULL,
    genero Enum('M','F','O')  NOT NULL,
    dataNascimento date  NOT NULL,
    cargo varchar(100)  NOT NULL,
    senha Text  NOT NULL,
    dataContratacao date  NOT NULL,
    setor varchar(30)  NOT NULL,
    role Enum('usuario','admin','operacional','comercial')  NOT NULL,
    CONSTRAINT usuario_pk PRIMARY KEY (id)
);

-- Table: usuario_local
CREATE TABLE usuario_local (
    id int  NOT NULL AUTO_INCREMENT,
    usuario_id int  NOT NULL,
    local Enum('Remoto','Presencial')  NOT NULL,
    data date  NOT NULL,
    CONSTRAINT usuario_local_pk PRIMARY KEY (id)
);

-- foreign keys
-- Reference: agendamento_cliente_cliente (table: agendamento_cliente)
ALTER TABLE agendamento_cliente ADD CONSTRAINT agendamento_cliente_cliente FOREIGN KEY agendamento_cliente_cliente (clienteId)
    REFERENCES cliente (Id);

-- Reference: cliente_association_1 (table: registro_cliente)
ALTER TABLE registro_cliente ADD CONSTRAINT cliente_association_1 FOREIGN KEY cliente_association_1 (clienteId)
    REFERENCES cliente (Id);

-- Reference: cliente_categoria_association_1 (table: registro_cliente)
ALTER TABLE registro_cliente ADD CONSTRAINT cliente_categoria_association_1 FOREIGN KEY cliente_categoria_association_1 (categoriaId)
    REFERENCES cliente_categoria (id);

-- Reference: cliente_tarefas (table: tarefas)
ALTER TABLE tarefas ADD CONSTRAINT cliente_tarefas FOREIGN KEY cliente_tarefas (cliente_Id)
    REFERENCES cliente (Id);

-- Reference: cotacao_cliente (table: cotacao)
ALTER TABLE cotacao ADD CONSTRAINT cotacao_cliente FOREIGN KEY cotacao_cliente (id_cliente)
    REFERENCES cliente (Id);

-- Reference: evento_association_1 (table: evento_convidado)
ALTER TABLE evento_convidado ADD CONSTRAINT evento_association_1 FOREIGN KEY evento_association_1 (evento_id)
    REFERENCES evento (id);

-- Reference: evento_association_2 (table: evento_resposta)
ALTER TABLE evento_resposta ADD CONSTRAINT evento_association_2 FOREIGN KEY evento_association_2 (evento_id)
    REFERENCES evento (id);

-- Reference: usuario_association_1 (table: evento_convidado)
ALTER TABLE evento_convidado ADD CONSTRAINT usuario_association_1 FOREIGN KEY usuario_association_1 (usuario_id)
    REFERENCES usuario (id);

-- Reference: usuario_association_2 (table: evento_resposta)
ALTER TABLE evento_resposta ADD CONSTRAINT usuario_association_2 FOREIGN KEY usuario_association_2 (usuario_id)
    REFERENCES usuario (id);

-- Reference: usuario_local_usuario (table: usuario_local)
ALTER TABLE usuario_local ADD CONSTRAINT usuario_local_usuario FOREIGN KEY usuario_local_usuario (usuario_id)
    REFERENCES usuario (id);

-- Reference: usuario_tarefas (table: tarefas)
ALTER TABLE tarefas ADD CONSTRAINT usuario_tarefas FOREIGN KEY usuario_tarefas (vendedor_id)
    REFERENCES usuario (id);

-- End of file.

