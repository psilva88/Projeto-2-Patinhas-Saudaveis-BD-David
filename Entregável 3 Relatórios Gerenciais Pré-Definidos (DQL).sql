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