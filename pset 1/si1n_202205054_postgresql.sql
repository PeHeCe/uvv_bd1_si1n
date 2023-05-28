--Conexão direta
--export PGPASSWORD=computacao@raiz 
--psql -U postgres < si1n_202205054_postgresql.sql

--Comando para analisar se já está cadastrado e excluir o banco de dados
DROP DATABASE IF EXISTS uvv;


--Comando para analisar se já está cadastrado e excluir o schema;
DROP SCHEMA IF EXISTS lojas;


--Comando para analisar se já está cadastrado e excluir o usuario;	
DROP USER IF EXISTS pedrohc;


--Criação de um usuario com permissões especificas
CREATE USER pedrohc WITH CREATEDB CREATEROLE ENCRYPTED PASSWORD '17pehece';
SET ROLE pedrohc;


--Criação de um banco de dados
CREATE DATABASE uvv WITH
                    owner = pedrohc
                    template = template0
                    encoding = "UTF8"
                    lc_collate = 'pt_BR.UTF-8'
                    lc_ctype = 'pt_BR.UTF-8'
                    allow_connections = TRUE;

ALTER database uvv owner TO pedrohc;

--Comentario referente ao banco de dados 'uvv'
COMMENT ON DATABASE uvv IS 'Esse é um banco de dados, com os dados de lojas uvv';


--Troca da conexão
\c uvv;
SET ROLE pedrohc;



--Criação do schema de lojas
CREATE SCHEMA lojas AUTHORIZATION pedrohc;

--Comentario referente ao schema de lojas
COMMENT ON SCHEMA  lojas IS 'Criação do esquema lojas';


--Alteração do search_path e do usuario no search_path
ALTER USER pedrohc
SET SEARCH_PATH TO lojas, "$user", public;




--Criacão da tabela produtos
CREATE TABLE produtos (
                produto_id                NUMERIC(38)  NOT NULL,
                nome                      VARCHAR(255) NOT NULL,
                preco_unitario            NUMERIC(10,2),
                detalhes BYTEA,
                imagem BYTEA,
                imagem_mime_type          VARCHAR(512),
                imagem_arquivo            VARCHAR(512),
                imagem_charset            VARCHAR(512),
                imagem_ultima_atualizacao DATE,
                                          CONSTRAINT pk_produtos PRIMARY KEY (produto_id)
);

--Comentarios referentes à tabela produtos e suas colunas
COMMENT ON TABLE produtos                            IS        'Nessa tabela tem os dados relacionados aos produtos';
COMMENT ON COLUMN produtos.produto_id                IS        'Essa coluna contém o id dos produtos';
COMMENT ON COLUMN produtos.nome                      IS        'Essa coluna contém o nome dos produtos';
COMMENT ON COLUMN produtos.preco_unitario            IS        'Essa coluna contém o preço dos produtos por unidade';
COMMENT ON COLUMN produtos.detalhes                  IS        'Essa coluna contém os detalhes sobre os produtos';
COMMENT ON COLUMN produtos.imagem                    IS        'Essa coluna contém imagens relacionadas aos produtos';
COMMENT ON COLUMN produtos.imagem_mime_type          IS        'Essa coluna contém imagens do tipo mime type relacionadas aos produtos';
COMMENT ON COLUMN produtos.imagem_arquivo            IS        'Essa coluna contém o arquivo das imagens dos produtos';
COMMENT ON COLUMN produtos.imagem_charset            IS        'Essa coluna contém imagens no formato charset relacionados aos produtos';
COMMENT ON COLUMN produtos.imagem_ultima_atualizacao IS        'Essa coluna contém a data da ultima atualizacao da imagem de cada produto';



--Criacão da tabela lojas
CREATE TABLE lojas (
                loja_id                    NUMERIC(38)  NOT NULL,
                nome                       VARCHAR(255) NOT NULL,
                endereco_web               VARCHAR(100),
                endereco_fisico            VARCHAR(512),
                latitude                   NUMERIC,
                longitude                  NUMERIC,
                logo                       BYTEA,
                logo_mime_type             VARCHAR(512),
                logo_arquivo               VARCHAR(512),
                logo_charset               VARCHAR(512),
                logo_ultima_atualizacao    DATE,
                                           CONSTRAINT pk_lojas PRIMARY KEY (loja_id)
);

--Comentarios referentes à tabela lojas e suas colunas
COMMENT ON COLUMN lojas.loja_id                 IS              'Essa coluna é uma chave primaria e contém os identificadores das lojas';
COMMENT ON COLUMN lojas.nome                    IS              'Essa coluna contém o nome das lojas';
COMMENT ON COLUMN lojas.endereco_web            IS              'Essa coluna contém os enderecos de web das lojas';
COMMENT ON COLUMN lojas.endereco_fisico         IS              'Essa coluna contém os enderecos fisicos dass lojas';
COMMENT ON COLUMN lojas.latitude                IS              'Essa coluna contém a latitude de localização das lojas';
COMMENT ON COLUMN lojas.longitude               IS              'Essa coluna contém a longitude de localização das lojas';
COMMENT ON COLUMN lojas.logo                    IS              'Essa coluna contém a logo das lojas';
COMMENT ON COLUMN lojas.logo_mime_type          IS              'Essa coluna contém as logos das lojas no formato mime type';
COMMENT ON COLUMN lojas.logo_arquivo            IS              'Essa coluna contém o arquivo das logos das lojas';
COMMENT ON COLUMN lojas.logo_charset            IS              'Essa coluna contém o charset das logos das lojas';
COMMENT ON COLUMN lojas.logo_ultima_atualizacao IS              'Essa coluna contém a data da ultima atualização da logo de cada loja';



--Criacão da tabela estoques
CREATE TABLE estoques (
                estoque_id                NUMERIC(38) NOT NULL,
                loja_id                   NUMERIC(38) NOT NULL,
                produto_id                NUMERIC(38) NOT NULL,
                quantidade                NUMERIC(38) NOT NULL,
                CONSTRAINT pk_estoques PRIMARY KEY (estoque_id)
); 

--Comentarios referentes à tabela estoques e suas colunas
COMMENT ON COLUMN estoques.estoque_id IS                 'Essa coluna contém o id de cada estoque';
COMMENT ON COLUMN estoques.loja_id    IS                 'Essa coluna contém a FK do id das lojas';
COMMENT ON COLUMN estoques.produto_id IS                 'Essa coluna contém a FK do id de cada produto';
COMMENT ON COLUMN estoques.quantidade IS                 'Essa coluna contém a quantidade do estoque';



--Criacão da tabela clientes
CREATE TABLE clientes (
                cliente_id                NUMERIC(38)  NOT NULL,
                email                     VARCHAR(255) NOT NULL,
                nome                      VARCHAR(255) NOT NULL,
                telefone1                 VARCHAR(20),
                telefone2                 VARCHAR(20),
                telefone3                 VARCHAR(20),
                                          CONSTRAINT pk_clientes PRIMARY KEY (cliente_id)
);

--Comentarios referentes à tabela clientes e suas colunas
COMMENT ON TABLE clientes             IS                 'Essa é uma tabela com dados dos clientes';
COMMENT ON COLUMN clientes.cliente_id IS                 'Nessa coluna estão os identificadores dos clientes';
COMMENT ON COLUMN clientes.email      IS                 'Essa coluna contém o email  de cada cliente';
COMMENT ON COLUMN clientes.nome       IS                 'Essa coluna contém o nome de cada cliente';
COMMENT ON COLUMN clientes.telefone1  IS                 'Essa coluna contém o primeiro telefone do cliente';
COMMENT ON COLUMN clientes.telefone2  IS                 'Essa coluna contém o segundo telefone do cliente';
COMMENT ON COLUMN clientes.telefone3  IS                 'Essa coluna contém o terceiro telefone do cliente';



--Criacão da tabela envios
CREATE TABLE envios (
                envio_id                 NUMERIC(38)  NOT NULL,
                loja_id                  NUMERIC(38)  NOT NULL,
                cliente_id               NUMERIC(38)  NOT NULL,
                endereco_entrega         VARCHAR(512) NOT NULL,
                status                   VARCHAR(15)  NOT NULL,
                                         CONSTRAINT pk_envios PRIMARY KEY (envio_id)
);

--Comentarios referentes à tabela envios e suas colunas
COMMENT ON COLUMN envios.envio_id         IS             'Essa coluna contém o id de cada envio';
COMMENT ON COLUMN envios.loja_id          IS             'Essa coluna contém a FK do id das lojas';
COMMENT ON COLUMN envios.cliente_id       IS             'Essa coluna contém a FK do id dos clientes';
COMMENT ON COLUMN envios.endereco_entrega IS             'Essa coluna contém os enderecos de entrega de cada envio';
COMMENT ON COLUMN envios.status           IS             'Essa coluna contém o status de cada pedido';



--Criacão da tabela pedidos
CREATE TABLE pedidos (
                pedido_id               NUMERIC(38) NOT NULL,
                data_hora               TIMESTAMP   NOT NULL,
                cliente_id              NUMERIC(38) NOT NULL,
                status                  VARCHAR(15) NOT NULL,
                loja_id                 NUMERIC(38) NOT NULL,
                                        CONSTRAINT pk_pedidos PRIMARY KEY (pedido_id)
);

--Comentarios referentes à tabela pedidos e suas colunas
COMMENT ON COLUMN pedidos.pedido_id  IS                  'Essa coluna contém o id de cada pedido';
COMMENT ON COLUMN pedidos.data_hora  IS                  'Essa coluna contém a data e hora de cada pedido';
COMMENT ON COLUMN pedidos.cliente_id IS                  'Essa coluna contém a FK de id dos clientes';
COMMENT ON COLUMN pedidos.status     IS                  'Essa coluna contém o status de cada pedido';
COMMENT ON COLUMN pedidos.loja_id    IS                  'Essa coluna contém a FK de id das lojas';



--Criacão da tabela pedidos_itens
CREATE TABLE pedidos_itens (
                pedido_id            NUMERIC(38)   NOT NULL,
                produto_id           NUMERIC(38)   NOT NULL,
                numero_da_linha      NUMERIC(38)   NOT NULL,
                preco_unitario       NUMERIC(10,2) NOT NULL,
                quantidade           NUMERIC(38)   NOT NULL,
                envio_id             NUMERIC(38),
                                     CONSTRAINT pk_pedidos_itens PRIMARY KEY (pedido_id, produto_id)
);

--Comentarios referentes à tabela pedidos_itens e suas colunas
COMMENT ON COLUMN pedidos_itens.pedido_id       IS       'Essa coluna contém o id dos pedidos';
COMMENT ON COLUMN pedidos_itens.produto_id      IS       'Essa coluna contém o id dos produtos';
COMMENT ON COLUMN pedidos_itens.numero_da_linha IS       'Essa coluna contém o numero da linha dos itens dos pedidos';
COMMENT ON COLUMN pedidos_itens.preco_unitario  IS       'Essa coluna contém o preço unitario dos itens dos pedidos';
COMMENT ON COLUMN pedidos_itens.quantidade      IS       'Essa coluna contém a quantidade de itens por pedido';
COMMENT ON COLUMN pedidos_itens.envio_id        IS       'Essa coluna contém a fk do is dos envios';





 
--Criação de relacionamento entre as tabelas: pedidos_itens e produtos por meio da coluna produto_id
ALTER TABLE pedidos_itens ADD CONSTRAINT produtos_pedidos_itens_fk
FOREIGN KEY (produto_id)
REFERENCES produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Criação de relacionamento entre as tabelas: estoques e produtos por meio da coluna produto_id
ALTER TABLE estoques ADD CONSTRAINT produtos_estoques_fk
FOREIGN KEY (produto_id)
REFERENCES produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Criação de relacionamento entre as tabelas: pedidos e lojas por meio da coluna loja_id
ALTER TABLE pedidos ADD CONSTRAINT lojas_pedidos_fk
FOREIGN KEY (loja_id)
REFERENCES lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Criação de relacionamento entre as tabelas: envios e lojas por meio da coluna loja_id
ALTER TABLE envios ADD CONSTRAINT lojas_envios_fk
FOREIGN KEY (loja_id)
REFERENCES lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Criação de relacionamento entre as tabelas: estoques e lojas por meio da coluna loja_id
ALTER TABLE estoques ADD CONSTRAINT lojas_estoques_fk
FOREIGN KEY (loja_id)
REFERENCES lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Criação de relacionamento entre as tabelas: pedidos e clientes por meio da coluna cliente_id
ALTER TABLE pedidos ADD CONSTRAINT clientes_pedidos_fk
FOREIGN KEY (cliente_id)
REFERENCES clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Criação de relacionamento entre as tabelas: envios e clientes por meio da coluna cliente_id
ALTER TABLE envios ADD CONSTRAINT clientes_envios_fk
FOREIGN KEY (cliente_id)
REFERENCES clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Criação de relacionamento entre as tabelas: pedidos_itens e envios por meio da coluna envio_id
ALTER TABLE pedidos_itens ADD CONSTRAINT envios_pedidos_itens_fk
FOREIGN KEY (envio_id)
REFERENCES envios (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Criação de relacionamento entre as tabelas: pedidos_itens e pedidos por meio da coluna pedido_id
ALTER TABLE pedidos_itens ADD CONSTRAINT pedidos_pedidos_itens_fk
FOREIGN KEY (pedido_id)
REFERENCES pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;



-- Adicionando restrição de verificação ao campo "status" da tabela de pedidos
ALTER TABLE pedidos
ADD CONSTRAINT pedidos_status_check   CHECK (status IN (
                                                    'CANCELADO',
                                                    'COMPLETO', 
                                                    'ABERTO', 
                                                    'PAGO',
                                                    'REEMBOLSADO',
                                                    'ENVIADO'
                                                    ));

-- Adicionando restrição de verificação ao campo "status" da tabela de envios
ALTER TABLE envios
ADD CONSTRAINT envios_status_check    CHECK (status IN ('CRIADO','ENVIADO', 'TRANSITO','ENTREGUE'));


--Verificação aos campos endereço_web e endereço_fisico da tabela de lojas, onde ao menos um deles deve ser preenchido
ALTER TABLE lojas
ADD CONSTRAINT ck_endereco_preenchido CHECK (endereco_web IS NOT NULL OR endereco_fisico IS NOT NULL);

                                           
-- Verificação para garantir que o preço_unitario seja maior ou igual a zero
ALTER TABLE produtos
ADD CONSTRAINT ck_preco_unitario      CHECK (preco_unitario >= 0);


-- Verificação para garantir que a latitude esteja dentro do intervalo válido (-90 a 90)
ALTER TABLE lojas
ADD CONSTRAINT ck_latitude            CHECK (latitude >= -90 AND latitude <= 90);


-- Verificação para garantir que a longitude esteja dentro do intervalo válido (-180 a 180)
ALTER TABLE lojas
ADD CONSTRAINT ck_longitude           CHECK (longitude >= -180 AND longitude <= 180);


-- Verificação para garantir que a quantidade seja maior ou igual a zero
ALTER TABLE estoques
ADD CONSTRAINT ck_quantidade          CHECK (quantidade >= 0);


-- Verificação para garantir que o email seja um endereço de email válido
ALTER TABLE clientes
ADD CONSTRAINT ck_email               CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');






