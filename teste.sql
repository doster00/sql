-- Questão 1
-- tabela de cargos
CREATE TABLE tb_cargo (
	id SERIAL PRIMARY KEY,
	nome VARCHAR(50) NOT NULL
);

-- tabela de orgaos
CREATE TABLE tb_orgao (
	id SERIAL PRIMARY KEY,
	nome VARCHAR(50) NOT NULL
);

-- tabela de usuarios
CREATE TABLE tb_usuario (
	cpf VARCHAR(11) PRIMARY KEY,
	nome VARCHAR(60) NOT NULL,
	email VARCHAR(50) UNIQUE NOT NULL,
	senha VARCHAR(255) NOT NULL,
	id_cargo INTEGER,
	id_orgao INTEGER,
	CONSTRAINT fk_usuario_cargo FOREIGN KEY (id_cargo) REFERENCES tb_cargo(id),
	CONSTRAINT fk_usuario_orgao FOREIGN KEY (id_orgao) REFERENCES tb_orgao(id)
);

-- tabela de sistemas
CREATE TABLE tb_sistema (
	id SERIAL PRIMARY KEY,
	nome VARCHAR(30) NOT NULL
);

-- tabela de ligacao entre usuarios e sistemas
CREATE TABLE tb_usuario_sistema(
	id_usuario VARCHAR(11) NOT NULL,
	id_sistema INTEGER NOT NULL,
	CONSTRAINT fk_usuario_sistema_usuario FOREIGN KEY (id_usuario) REFERENCES tb_usuario(cpf),
	CONSTRAINT fk_usuario_sistema_sistema FOREIGN KEY (id_sistema) REFERENCES tb_sistema(id)
);

-- Questão 2
-- carga da tabela de cargos
INSERT INTO tb_cargo (nome) VALUES ('Desenvolvedor');
INSERT INTO tb_cargo (nome) VALUES ('Analista de sistemas');
INSERT INTO tb_cargo (nome) VALUES ('Analista de requisitos');
INSERT INTO tb_cargo (nome) VALUES ('Arquiteto de software');
INSERT INTO tb_cargo (nome) VALUES ('Gerente de projetos');

-- carga da tabela de orgaos
INSERT INTO tb_orgao (nome) VALUES ('Secretaria A');
INSERT INTO tb_orgao (nome) VALUES ('Secretaria B');
INSERT INTO tb_orgao (nome) VALUES ('Secretaria C');

-- carga da tabela de sistemas
INSERT INTO tb_sistema (nome) VALUES ('Sistema de cadastro de pessoas');
INSERT INTO tb_sistema (nome) VALUES ('Sistema de cotações');
INSERT INTO tb_sistema (nome) VALUES ('Sistema de calculos');
INSERT INTO tb_sistema (nome) VALUES ('Sistema de autenticação');

-- carga da tabela de usuarios
INSERT INTO tb_usuario (cpf, nome, email, senha, id_cargo, id_orgao) VALUES ('01234567890', 'Adriano Silva', 'adriano@email.com', '@dr1@n0', 1, 2);
INSERT INTO tb_usuario (cpf, nome, email, senha, id_cargo, id_orgao) VALUES ('12345678901', 'Mariana Karla', 'mariana@email.com', 'm@r1@n@', 1, 3);
INSERT INTO tb_usuario (cpf, nome, email, senha, id_cargo, id_orgao) VALUES ('23456789012', 'Lucas Bastos', 'lucas@email.com', 'luc@s', 3, 1);
INSERT INTO tb_usuario (cpf, nome, email, senha, id_cargo, id_orgao) VALUES ('34567890123', 'Sabrina Barbosa', 'sabrina@email.com', 's@br1n@', 3, 1);

-- criando vinculos entre os usuarios e os sistemas
INSERT INTO tb_usuario_sistema (id_usuario, id_sistema) VALUES ('01234567890', 2);
INSERT INTO tb_usuario_sistema (id_usuario, id_sistema) VALUES ('01234567890', 1);
INSERT INTO tb_usuario_sistema (id_usuario, id_sistema) VALUES ('23456789012', 1);
INSERT INTO tb_usuario_sistema (id_usuario, id_sistema) VALUES ('34567890123', 1);

-- Questão 3
-- criacao de uma view para guardar os usuarios e seus respectivos sistemas
create view vw_usuario_sistema (cpf, sistemas) as (
	select usuario_sistema.id_usuario as cpf, array_agg(sistema.nome) as sistemas from tb_sistema sistema 
	inner join tb_usuario_sistema usuario_sistema on usuario_sistema.id_sistema = sistema.id
	group by usuario_sistema.id_usuario
);

-- chamada para a view
select * from vw_usuario_sistema;

-- retornando todos os usuarios
select 
	regexp_replace(usuario.cpf, '(\d{3})(\d{3})(\d{3})(\d{2})',  '\1.\2.\3-\4') AS cpf, -- aplica a mascara de cpf
	upper(usuario.nome) as nome, -- funcao UPPER do postgres torna o texto maiusculo
	upper(cargo.nome) as cargo,
	upper(orgao.nome) as orgao,
	upper(sistema.nome) as sistema
from tb_usuario usuario
	left join tb_cargo cargo on usuario.id_cargo = cargo.id
	left join tb_orgao orgao on usuario.id_orgao = orgao.id
	left join tb_usuario_sistema usuario_sistema on usuario.cpf = usuario_sistema.id_usuario
	left join tb_sistema sistema on usuario_sistema.id_sistema = sistema.id;

-- Adicional
-- solucao para exibir a quantidade de sistemas vinculados a determinado usuario
select usuario_sistema.id_usuario as cpf, count(sistema.nome) as quantidade_sistemas from tb_sistema sistema 
	inner join tb_usuario_sistema usuario_sistema on usuario_sistema.id_sistema = sistema.id
	group by usuario_sistema.id_usuario;

	