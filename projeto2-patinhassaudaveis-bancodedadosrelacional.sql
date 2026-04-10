CREATE DATABASE patinhas_saudaveis;
USE patinhas_saudaveis;

-- Entregável 2: Implementação e Povoamento (Script DDL e DML)

-- TABELAS PAI (Independentes)
CREATE TABLE CLIENTE (
    cpf VARCHAR(14) PRIMARY KEY,
    nome_completo VARCHAR(100) NOT NULL,
    endereco VARCHAR(200)
);

CREATE TABLE PROFISSIONAL (
    matricula INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cargo_funcao VARCHAR(50),
    crmv VARCHAR(20)
);

CREATE TABLE SERVICO (
    cod_servico INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(100),
    preco_base DECIMAL(10,2)
);

CREATE TABLE PRODUTO (
    cod_barras VARCHAR(50) PRIMARY KEY,
    nome_produto VARCHAR(100),
    preco_venda DECIMAL(10,2),
    qtd_estoque INT
);

CREATE TABLE VACINA (
    cod_vacina INT AUTO_INCREMENT PRIMARY KEY,
    nome_vacina VARCHAR(50),
    prazo_revacinacao_dias INT
);

-- TABELAS DEPENDENTES (Chaves Estrangeiras)
CREATE TABLE TELEFONE_CLIENTE (
    cpf_cliente VARCHAR(14),
    numero_telefone VARCHAR(20),
    PRIMARY KEY (cpf_cliente, numero_telefone),
    FOREIGN KEY (cpf_cliente) REFERENCES CLIENTE(cpf) ON DELETE CASCADE
);

CREATE TABLE PET (
    cod_pet INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    especie VARCHAR(30),
    raca VARCHAR(50),
    data_nascimento DATE,
    sexo ENUM('M', 'F'),
    cpf_cliente VARCHAR(14),
    FOREIGN KEY (cpf_cliente) REFERENCES CLIENTE(cpf)
);

CREATE TABLE TELEFONE_PROFISSIONAL (
    matricula_profissional INT,
    numero_telefone VARCHAR(20),
    PRIMARY KEY (matricula_profissional, numero_telefone),
    FOREIGN KEY (matricula_profissional) REFERENCES PROFISSIONAL(matricula) ON DELETE CASCADE
);

CREATE TABLE DIAS_TRABALHO (
    matricula_profissional INT,
    dia_semana VARCHAR(20),
    PRIMARY KEY (matricula_profissional, dia_semana),
    FOREIGN KEY (matricula_profissional) REFERENCES PROFISSIONAL(matricula)
);

-- TABELAS DE MOVIMENTAÇÃO (O Coração do Sistema)
CREATE TABLE AGENDAMENTO_PRONTUARIO (
    num_registro INT AUTO_INCREMENT PRIMARY KEY,
    data_consulta DATE NOT NULL,
    hora TIME NOT NULL,
    peso_atual DECIMAL(5,2),
    sintomas TEXT,
    diagnostico TEXT,
    cod_vacina INT,
    cpf_cliente VARCHAR(14),
    cod_pet INT,
    matricula_profissional INT,
    cod_servico INT,
    FOREIGN KEY (cod_vacina) REFERENCES VACINA(cod_vacina),
    FOREIGN KEY (cpf_cliente) REFERENCES CLIENTE(cpf),
    FOREIGN KEY (cod_pet) REFERENCES PET(cod_pet),
    FOREIGN KEY (matricula_profissional) REFERENCES PROFISSIONAL(matricula),
    FOREIGN KEY (cod_servico) REFERENCES SERVICO(cod_servico)
);

CREATE TABLE MEDICAMENTO_RECEITADO (
    num_registro_agendamento INT,
    nome_medicamento VARCHAR(100),
    PRIMARY KEY (num_registro_agendamento, nome_medicamento),
    FOREIGN KEY (num_registro_agendamento) REFERENCES AGENDAMENTO_PRONTUARIO(num_registro)
);

CREATE TABLE FATURA_CAIXA (
    num_fatura INT AUTO_INCREMENT PRIMARY KEY,
    data_emissao DATE,
    valor_total DECIMAL(10,2),
    cpf_cliente VARCHAR(14),
    FOREIGN KEY (cpf_cliente) REFERENCES CLIENTE(cpf)
);

CREATE TABLE ITEM_FATURA (
    num_fatura INT,
    cod_item VARCHAR(50),
    tipo_item ENUM('Produto', 'Servico'),
    qtd INT,
    preco_unitario DECIMAL(10,2),
    PRIMARY KEY (num_fatura, cod_item),
    FOREIGN KEY (num_fatura) REFERENCES FATURA_CAIXA(num_fatura)
);

-- 1. CLIENTES (20 registros)
INSERT INTO CLIENTE (cpf, nome_completo, endereco) VALUES
('111.111.111-11', 'Arthur Pereira Silva', 'Rua das Flores, 100'),
('222.222.222-22', 'Bernardo Ramos Santos', 'Av. Brasília, 500'),
('333.333.333-33', 'Rodrigo Lira Rodrigues', 'Rua Estreita, 12'),
('444.444.444-44', 'Luiz Gustavo Machado', 'Rua Larga, 45'),
('555.555.555-55', 'Vinicius Sales Araujo', 'Av. Getúlio Vargas, 900'),
('666.666.666-66', 'Gustavo Torres Muniz', 'Rua do Sol, 202'),
('777.777.777-77', 'Lucas Souto Maior Nobrega', 'Rua da Lua, 303'),
('888.888.888-88', 'Ozônio Marcos de Fifa', 'Av. Principal, 1010'),
('999.999.999-99', 'Renato das Nega Barbosa', 'Rua das Palmeiras, 55'),
('101.101.101-01', 'Tite Kubo', 'Rua dos Mangás, 88'),
('202.202.202-02', 'Luis Henrique', 'Rua da Paz, 777'),
('303.303.303-03', 'Ricardo Teixeira', 'Rua de Cima, 10'),
('404.404.404-04', 'Seu Elvis da Silva Pereira', 'Rua de Baixo, 20'),
('505.505.505-05', 'Cyntya Lorena Pereira da Silva', 'Av. Roberto Dinamite, 1923'),
('606.606.606-06', 'Adolfo Pereira da Perdeineira', 'Rua do Clássica, 40'),
('707.707.707-07', 'Chupinha Alencar da Chapa', 'Rua Feliz, 99'),
('808.808.808-08', 'Paulista da Duda', 'Rua da Passarela, 1'),
('909.909.909-09', 'Alynton Senna Silva', 'Av. Interlagos, 400'),
('121.212.121-21', 'Lula Bolsonaro do Trump Silva', 'Rua do Carnaval, 2026'),
('232.323.232-23', 'Yamamoto Zaraki Kyoraku Shinji da Silva Pereira dos Santos Society', 'Soul Society Sereitei, 42');

-- 2. PROFISSIONAIS (5 registros)
INSERT INTO PROFISSIONAL (matricula, nome, cargo_funcao, crmv) VALUES
(1001, 'Dr. Luiz Gustavo', 'Veterinário Geral', 'CRMV-PB 4567'),
(1002, 'Dra. Ana Luísa', 'Cirurgiã', 'CRMV-PB 8899'),
(1003, 'Dr. Marcos Oliveira', 'Anestesista', 'CRMV-PB 1212'),
(2001, 'Beatriz Souza', 'Recepcionista', NULL),
(2002, 'Carlos Alberto', 'Auxiliar de Tosa', NULL);

-- 3. SERVIÇOS (5 registros)
INSERT INTO SERVICO (descricao, preco_base) VALUES
('Consulta Geral', 150.00),
('Vacinação', 80.00),
('Cirurgia de Castração', 450.00),
('Banho e Tosa Completo', 120.00),
('Exame de Sangue', 90.00);

-- 4. VACINAS (5 registros)
INSERT INTO VACINA (nome_vacina, prazo_revacinacao_dias) VALUES
('Antirrábica', 365),
('V10 (Cães)', 365),
('Quíntupla (Gatos)', 365),
('Gripe Canina', 180),
('Giárdia', 180);

-- 5. PRODUTOS (15 registros)
INSERT INTO PRODUTO (cod_barras, nome_produto, preco_venda, qtd_estoque) VALUES
('789101', 'Ração Golden Adulto 15kg', 180.00, 50),
('789102', 'Ração Royal Canin Gatos 2kg', 110.00, 30),
('789103', 'Brinquedo Mordedor Osso', 25.00, 100),
('789104', 'Shampoo Pet Neutro', 35.00, 40),
('789105', 'Coleira Antipulgas', 65.00, 25),
('789106', 'Petisco para Cães Carne', 15.00, 200),
('789107', 'Sachê Whiskas Carne', 4.50, 300),
('789108', 'Areia Sanitária 4kg', 22.00, 60),
('789109', 'Cama Pet Média', 120.00, 15),
('789110', 'Remédio Vermífugo', 45.00, 80),
('789111', 'Caixa de Transporte P', 95.00, 10),
('789112', 'Arranhador para Gatos', 150.00, 8),
('789113', 'Bebedouro Automático', 55.00, 20),
('789114', 'Escova de Pelos', 28.00, 35),
('789115', 'Guia Retrátil 5m', 75.00, 12);

-- 6. PETS (20 registros)
INSERT INTO PET (nome, especie, raca, data_nascimento, sexo, cpf_cliente) VALUES
('Rex', 'Cão', 'Labrador', '2022-01-10', 'M', '111.111.111-11'),
('Luna', 'Cão', 'Poodle', '2021-05-20', 'F', '111.111.111-11'),
('Thor', 'Cão', 'Golden', '2023-03-15', 'M', '222.222.222-22'),
('Mel', 'Cão', 'SRD', '2020-11-02', 'F', '333.333.333-33'),
('Bidu', 'Cão', 'Schnauzer', '2019-08-12', 'M', '444.444.444-44'),
('Mingau', 'Gato', 'Persa', '2022-10-10', 'M', '555.555.555-55'),
('Nina', 'Gato', 'Siamês', '2021-02-28', 'F', '666.666.666-66'),
('Simba', 'Cão', 'Pinscher', '2023-01-01', 'M', '777.777.777-77'),
('Piu Piu', 'Ave', 'Calopsita', '2022-07-07', 'F', '888.888.888-88'),
('Loro José', 'Ave', 'Papagaio', '2018-12-25', 'M', '999.999.999-99'),
('Lola', 'Cão', 'Shih Tzu', '2021-06-18', 'F', '101.101.101-01'),
('Bob', 'Cão', 'Bulldog', '2020-04-30', 'M', '202.202.202-02'),
('Fred', 'Cão', 'Dachshund', '2019-09-09', 'M', '303.303.303-03'),
('Bela', 'Gato', 'Maine Coon', '2023-05-12', 'F', '404.404.404-04'),
('Kadu', 'Cão', 'Chihuahua', '2022-11-11', 'M', '505.505.505-05'),
('Mia', 'Gato', 'Angorá', '2021-08-20', 'F', '606.606.606-06'),
('Jack', 'Cão', 'Pitbull', '2020-02-14', 'M', '707.707.707-07'),
('Gisele Pet', 'Cão', 'Galgo', '2022-03-20', 'F', '808.808.808-08'),
('Veloz', 'Cão', 'Pastor Alemão', '2021-09-30', 'M', '909.909.909-09'),
('Dengo', 'Cão', 'Pug', '2023-06-01', 'F', '121.212.121-21');

-- 7. AGENDAMENTOS (15 registros)
INSERT INTO AGENDAMENTO_PRONTUARIO (data_consulta, hora, peso_atual, sintomas, diagnostico, cod_vacina, cpf_cliente, cod_pet, matricula_profissional, cod_servico) VALUES
('2026-04-01', '08:30', 25.5, 'Febre', 'Infecção Viral', 2, '111.111.111-11', 1, 1001, 1),
('2026-04-02', '09:00', 5.2, 'Check-up', 'Saudável', NULL, '111.111.111-11', 2, 1001, 1),
('2026-04-03', '10:00', 30.0, 'Vacinação Anual', 'Aplicação OK', 1, '222.222.222-22', 3, 1001, 2),
('2026-04-05', '14:30', 8.4, 'Vômito', 'Gastrite', NULL, '333.333.333-33', 4, 1001, 1),
('2026-04-06', '15:00', 7.1, 'Castração', 'Pós-operatório estável', NULL, '444.444.444-44', 5, 1002, 3),
('2026-04-07', '08:00', 4.8, 'Banho', 'Limpo e Tosado', NULL, '555.555.555-55', 6, 2002, 4),
('2026-04-08', '11:00', 3.5, 'Coceira', 'Dermatite', NULL, '666.666.666-66', 7, 1001, 1),
('2026-04-09', '09:30', 2.1, 'Vacina Gripe', 'Aplicação OK', 4, '777.777.777-77', 8, 1001, 2),
('2026-04-10', '16:00', 12.4, 'Exame de Rotina', 'Tudo Normal', NULL, '888.888.888-88', 9, 1001, 5),
('2026-04-11', '10:30', 9.8, 'Dor na Pata', 'Luxação leve', NULL, '999.999.999-99', 10, 1001, 1),
('2026-04-12', '14:00', 6.5, 'Ouvido Sujo', 'Otite', NULL, '101.101.101-01', 11, 1001, 1),
('2026-04-13', '15:30', 22.0, 'Vacina Raiva', 'Aplicação OK', 1, '202.202.202-02', 12, 1001, 2),
('2026-04-14', '08:45', 10.2, 'Tosa Verão', 'OK', NULL, '303.303.303-03', 13, 2002, 4),
('2026-04-15', '11:15', 15.0, 'Olhos Vermelhos', 'Conjuntivite', NULL, '404.404.404-04', 14, 1001, 1),
('2026-04-16', '09:00', 3.4, 'Check-up Filhote', 'Saudável', NULL, '505.505.505-05', 15, 1001, 1);

-- 8. FATURAS (10 registros)
INSERT INTO FATURA_CAIXA (data_emissao, valor_total, cpf_cliente) VALUES
('2026-04-01', 150.00, '111.111.111-11'),
('2026-04-03', 80.00, '222.222.222-22'),
('2026-04-05', 180.00, '333.333.333-33'),
('2026-04-07', 120.00, '555.555.555-55'),
('2026-04-09', 25.00, '777.777.777-77'),
('2026-04-11', 45.00, '999.999.999-99'),
('2026-04-13', 200.00, '202.202.202-02'),
('2026-04-14', 120.00, '303.303.303-03'),
('2026-04-15', 35.00, '404.404.404-04'),
('2026-04-16', 150.00, '505.505.505-05');

-- Entregável 3: Relatórios Gerenciais Pré-Definidos (DQL)
-- PARTE 1: As 5 Consultas Simples

-- 1. Organização Básica (ORDER BY)
-- Objetivo: Listar todos os clientes cadastrados em ordem alfabética.
SELECT cpf, nome_completo, endereco 
FROM CLIENTE 
ORDER BY nome_completo ASC;

-- 2. Motor de Busca de Texto (LIKE)
-- Objetivo: Buscar no estoque todos os produtos que tenham a palavra "Ração" em qualquer parte do nome.
SELECT cod_barras, nome_produto, qtd_estoque 
FROM PRODUTO 
WHERE nome_produto LIKE '%Ração%';

-- 3. Múltiplas Opções (IN)
-- Objetivo: Listar apenas os pets (Gatos e Aves) da clínica.
SELECT nome, especie, raca 
FROM PET 
WHERE especie IN ('Gato', 'Ave');

-- 4. Intervalo de Valores (BETWEEN)
-- Objetivo: Encontrar serviços na clínica que custem entre 50 e 150 reais.
SELECT descricao, preco_base 
FROM SERVICO 
WHERE preco_base BETWEEN 50.00 AND 150.00;

-- 5. Matemática Simples (AVG)
-- Objetivo: Descobrir qual é a média de preço de todos os produtos vendidos.
SELECT AVG(preco_venda) AS media_preco_produtos 
FROM PRODUTO;

-- PARTE 2: As 5 Consultas Complexas

-- 1. Cruzamento Básico (INNER JOIN)
-- Objetivo: Descobrir o nome do pet, sua espécie e o nome do seu dono (Cliente).
SELECT PET.nome AS Nome_Pet, PET.especie, CLIENTE.nome_completo AS Nome_Dono
FROM PET
INNER JOIN CLIENTE ON PET.cpf_cliente = CLIENTE.cpf
ORDER BY CLIENTE.nome_completo;

-- 2. A Busca Abrangente (LEFT JOIN)
-- Objetivo: Listar TODAS as vacinas cadastradas e cruzar com as consultas.
SELECT VACINA.nome_vacina, AGENDAMENTO_PRONTUARIO.data_consulta
FROM VACINA
LEFT JOIN AGENDAMENTO_PRONTUARIO ON VACINA.cod_vacina = AGENDAMENTO_PRONTUARIO.cod_vacina;

-- 3. Relatório de Desempenho (INNER JOIN + GROUP BY + COUNT)
-- Objetivo: Contar quantos atendimentos cada médico veterinário realizou na clínica.
SELECT PROFISSIONAL.nome AS Veterinario, COUNT(AGENDAMENTO_PRONTUARIO.num_registro) AS total_atendimentos
FROM PROFISSIONAL
INNER JOIN AGENDAMENTO_PRONTUARIO ON PROFISSIONAL.matricula = AGENDAMENTO_PRONTUARIO.matricula_profissional
GROUP BY PROFISSIONAL.nome;

-- 4. Cruzamento Triplo (Múltiplos INNER JOINs + WHERE)
-- Objetivo: Mostrar a agenda da clínica a partir de uma data específica.
SELECT AGENDAMENTO_PRONTUARIO.data_consulta, AGENDAMENTO_PRONTUARIO.hora, PET.nome AS Paciente_Pet, PROFISSIONAL.nome AS Doutor
FROM AGENDAMENTO_PRONTUARIO
INNER JOIN PET ON AGENDAMENTO_PRONTUARIO.cod_pet = PET.cod_pet
INNER JOIN PROFISSIONAL ON AGENDAMENTO_PRONTUARIO.matricula_profissional = PROFISSIONAL.matricula
WHERE AGENDAMENTO_PRONTUARIO.data_consulta >= '2026-04-01'
ORDER BY AGENDAMENTO_PRONTUARIO.data_consulta, AGENDAMENTO_PRONTUARIO.hora;

-- 5. Relatório Financeiro Final (INNER JOIN + GROUP BY + SUM)
-- Objetivo: Somar todas as faturas e descobrir qual é o valor total que cada cliente já gastou na clínica.
SELECT CLIENTE.nome_completo, SUM(FATURA_CAIXA.valor_total) AS total_gasto_cliente
FROM CLIENTE
INNER JOIN FATURA_CAIXA ON CLIENTE.cpf = FATURA_CAIXA.cpf_cliente
GROUP BY CLIENTE.nome_completo
ORDER BY total_gasto_cliente DESC;