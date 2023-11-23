CREATE DATABASE SecureATM;
DROP DATABASE SecureATM;
use SecureATM;

CREATE TABLE plano (
id_plano INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(45));

INSERT INTO plano VALUES (null, 'Standard');
INSERT INTO plano VALUES (null, 'Advanced');
INSERT INTO plano VALUES (null, 'Premium');

CREATE TABLE empresa (
id_empresa INT PRIMARY KEY AUTO_INCREMENT,
cnpj CHAR(14),
nome VARCHAR(45),
senha VARCHAR(45),
email VARCHAR(45),
razao_social VARCHAR(45),
fk_plano INT,
 CONSTRAINT fk_emp_plano FOREIGN KEY (fk_plano)
  REFERENCES plano (id_plano));

INSERT INTO empresa VALUES (NULL, "Bradesco", "34.223.147/0001-62", "bradesco123", 'bradesco@hotmail.com', 3);

CREATE TABLE associado (
id_associado INT AUTO_INCREMENT,
email VARCHAR(45),
fk_empresa INT,
 CONSTRAINT fk_emp_associado FOREIGN KEY (fk_empresa)
  REFERENCES empresa (id_empresa),
   PRIMARY KEY (id_associado, fk_empresa)
);

INSERT INTO associado VALUES (null, 'gabriel.bradesco@hotmail.com',1);

CREATE TABLE funcionario (
id_funcionario INT AUTO_INCREMENT,
nome VARCHAR(45),
email VARCHAR(45),
senha VARCHAR(64),
dt_nasc CHAR(10),
fk_empresa INT,
 CONSTRAINT fk_emp_funcionario FOREIGN KEY (fk_empresa)
  REFERENCES empresa (id_empresa),
   PRIMARY KEY (id_funcionario, fk_empresa));
   
INSERT INTO funcionario VALUES (NULL, "Gabriel", "gabriel.bradesco@hotmail.com", "123456", 1);

/* SELECT PARA VERIFICAR SE O EMAIL QUE O FUNCIONARIO CADASTROU ESTA ASSOCIADO A ALGUMA EMPRESA */
SELECT * FROM associado WHERE email = 'gabriel.bradesco@hotmail.com';

CREATE TABLE atm(
id_atm INT AUTO_INCREMENT,
modelo VARCHAR(45),
fabricante VARCHAR(45),
so VARCHAR(45),
processador VARCHAR(45),
ram VARCHAR(45),
qtd_disco INT,
fk_empresa INT,
 CONSTRAINT fk_emp_atm FOREIGN KEY (fk_empresa)
  REFERENCES empresa (id_empresa),
   PRIMARY KEY (id_atm, fk_empresa));
   
INSERT INTO atm VALUES (NULL, "NCR Corporation", "NCR SelfServ", "Windows", "Intel Core i3", "4 GB", "128 GB SSD", 1);

SELECT * FROM atm;

CREATE TABLE componente(
id_componente INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(45),
unidade INT,
descricao VARCHAR(45)
);

/* INSERINDO ATRIBUTOS DA CPU - INSIRA NESSA ORDEM*/
INSERT INTO componente VALUES (NULL, "cpu", "%", "porcentagem_utilizada");
INSERT INTO componente VALUES (NULL, "cpu", "GHz", "velocidade");
INSERT INTO componente VALUES (NULL, "cpu", "", "processos");
INSERT INTO componente VALUES (NULL, "cpu", "Segundos", "tempo_usuario");
INSERT INTO componente VALUES (NULL, "cpu", "Segundos", "tempo_sistema");


/* INSERINDO ATRIBUTOS DA MEMÓRIA - INSIRA NESSA ORDEM*/
INSERT INTO componente VALUES (NULL, "memoria", "GB", "capacidade_total");
INSERT INTO componente VALUES (NULL, "memoria", "GB", "capacidade_usada");
INSERT INTO componente VALUES (NULL, "memoria", "%", "porcentagem_utilizada");

/* INSERINDO ATRIBUTOS DE DISCO - INSIRA NESSA ORDEM*/
INSERT INTO componente VALUES (NULL, "disco", "", "nome_disco");
INSERT INTO componente VALUES (NULL, "disco", "", "sistema_de_arquivo");
INSERT INTO componente VALUES (NULL, "disco", "%", "porcentagem_utilizada");
INSERT INTO componente VALUES (NULL, "disco", "GB", "capacidade_total");
INSERT INTO componente VALUES (NULL, "disco", "GB", "capacidade_usada");
INSERT INTO componente VALUES (NULL, "disco", "", "leituras");
INSERT INTO componente VALUES (NULL, "disco", "", "escritas");

/* INSERINDO ATRIBUTOS DE REDE - INSIRA NESSA ORDEM*/
INSERT INTO componente VALUES (NULL, "rede", "", "nome_host");
INSERT INTO componente VALUES (NULL, "rede", "String", "endereco_ip");
INSERT INTO componente VALUES (NULL, "rede", "String", "tipo_conexao");
INSERT INTO componente VALUES (NULL, "rede", "Gbps", "velocidade");
INSERT INTO componente VALUES (NULL, "rede", "Bytes", "bytes_enviados");
INSERT INTO componente VALUES (NULL, "rede", "Byte", "bytes_recebidos");
INSERT INTO componente VALUES (NULL, "rede", "Ms", "latencia");

/* INSERINDO ATRIBUTOS DE SENSOR - INSIRA NESSA ORDEM*/
INSERT INTO componente VALUES (NULL, "sensor", "Boolean", "bateria_estado");
INSERT INTO componente VALUES (NULL, "sensor", "Data", "boot_tempo");
INSERT INTO componente VALUES (NULL, "sensor", "%", "porcentagem_bateria");

/* INSERINDO ATRIBUTOS DE JANELA DE SISTEMAS - INSIRA NESSA ORDEM*/
INSERT INTO componente VALUES (NULL, "janela_de_sistemas", "String", "janela_ativa");


SELECT * FROM componente;

CREATE TABLE leitura(
id_leitura INT PRIMARY KEY AUTO_INCREMENT,
data_registro DATETIME,
valor FLOAT,
fk_atm INT,
 CONSTRAINT fk_leitura_atm FOREIGN KEY (fk_atm)
  REFERENCES atm (id_atm),
  fk_componente INT,
 CONSTRAINT fk_leitura_componente FOREIGN KEY (fk_componente)
  REFERENCES componente (id_componente)
  );
  
  INSERT INTO leitura (id_leitura, valor, fk_atm, fk_componente) VALUES(NULL, "22.5", 1, 1);
  INSERT INTO leitura (id_leitura, valor, fk_atm, fk_componente) VALUES(NULL, "0.98", 1, 1);
  
  /* SELECT NA LEITURA COM BASE NO NOME DO COMPONENTE */
  SELECT * from leitura JOIN componente ON leitura.fk_componente = componente.id_componente
  WHERE componente.nome = "cpu";
  
  SELECT * from leitura;
  
  /* SELECT NA LEITURA COM BASE NA CPU */
  SELECT leitura.data_registro, leitura.valor, componente.nome, componente.descricao, componente.unidade FROM leitura JOIN componente ON leitura.fk_componente = componente.id_componente
  WHERE componente.nome = "cpu";
  
  /* SELECT NA LEITURA COM BASE NA MEMORIA */
  SELECT leitura.data_registro, leitura.valor, componente.nome, componente.descricao, componente.unidade FROM leitura JOIN componente ON leitura.fk_componente = componente.id_componente
  WHERE componente.nome = "memoria";
  
  /* SELECT NA LEITURA COM BASE NO DISCO */
  SELECT leitura.data_registro, leitura.valor, componente.nome, componente.descricao, componente.unidade FROM leitura JOIN componente ON leitura.fk_componente = componente.id_componente
  WHERE componente.nome = "disco";
  
  /* SELECT NA LEITURA COM BASE NO DISCO */
  SELECT leitura.data_registro, leitura.valor, componente.nome, componente.descricao, componente.unidade FROM leitura JOIN componente ON leitura.fk_componente = componente.id_componente
  WHERE componente.nome = "rede";
  
  /* SELECT NA LEITURA COM BASE NA JANELA DE SISTEMAS */
  SELECT leitura.data_registro, leitura.valor, componente.nome, componente.descricao, componente.unidade FROM leitura JOIN componente ON leitura.fk_componente = componente.id_componente
  WHERE componente.nome = "janela_de_sistemas";
  
  /* SELECT NA LEITURA COM BASE NO SENSOR */
  SELECT leitura.data_registro, leitura.valor, componente.nome, componente.descricao, componente.unidade FROM leitura JOIN componente ON leitura.fk_componente = componente.id_componente
  WHERE componente.nome = "sensor";
  
Select * from leitura;

   

