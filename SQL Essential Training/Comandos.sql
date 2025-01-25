--Practicing SQL 
SELECT	--Selecione
	5 + 7 -- Serve para retornar qualquer tipo de dado que eu pedir não necessariamente tem que ter uma tabela
--------------------------------------------
SELECT	--Selecione
	*
FROM    -- De
	Customer
--------------------------------------------
--Passing specific table columns
SELECT	
	FirstName,
	LastName,
	Address
FROM 
	Customer
--------------------------------------------
--Renaming table and Specifying 
SELECT	
	c.FirstName,
	c.LastName,
	c.Address
FROM 
	Customer c
--------------------------------------------
--Renaming Column
SELECT	
	c.FirstName AS Nome,
	c.LastName AS Sobrenome,
	c.Address AS Endereço
FROM 
	Customer c
	--or Customer AS C
--------------------------------------------
SELECT	--Selecione
	c.FirstName,
	c.LastName,
	c.Address
FROM    -- De
	Customer c
WHERE   -- Onde
	FirstName Like 'L%'  
	/*FirstName tiver L no começo(% significa que não importa subseguiente 
	ou anterior dependendo da posição que ele aparece).*/
--------------------------------------------
SELECT	
	c.CustomerId,
	c.FirstName,
	c.LastName,
	c.Address
FROM 
	Customer c
WHERE
	CustomerId > 20		-- OPERADORES(>, <, <=, >=, =, AND, OR, NOT, NOT IN, IN, BETWEEN, LIKE).
ORDER BY 	-- ORDENE POR//		O order by para tipo date o padrão é data antiga para data mais recente se colocar o DESC fica o contrário
	FirstName DESC --DESC Decrecente  ASC Crecente
--------------------------------------------	
SELECT	
	c.CustomerId,
	c.FirstName,
	c.LastName,
	c.Address
FROM 
	Customer c
LIMIT 10 -- LIMITA QUANTIDADE DE RESULTADOS EXIBIDOS
--------------------------------------------	
SELECT 
	* 
FROM 
	Funcionarios
ORDER BY 
	Nome
LIMIT 5 OFFSET 10;  -- (OFFSET PULA) OS 10 PRIMEIROS E EXIBE OS 5 PROXIMOS
--------------------------------------------	
SELECT
	REPLACE(FirstName, 'd', '-')	--APLICANDO REPLACE
FROM 
	Customer;
--AVG
SELECT	
	AVG(total)  --Média
FROM 
	Invoice
--MAX
SELECT	
	MAX(total)  --Máximo
FROM 
	Invoice

--MIN
SELECT	
	MIN(total) --Mínimo
FROM 
	Invoice
--SUM
SELECT	
	SUM(total)  --Soma
FROM 
	Invoice
--COUNT
SELECT	
	Count(total) --Quantidade de resultados
FROM 
	Invoice
--ROUND
SELECT	
	Round(AVG(total), 2) --Arredonda resultado
FROM 
	Invoice
--UPPER
SELECT	
	UPPER(BillingCity) --Coloca letra maiusculas
FROM 
	Invoice
--TRIM
SELECT	
	TRIM(BillingCity) --Remove espaços excedentes
FROM 
	Invoice
--LOWER
SELECT	
	LOWER(BillingCity)  --Coloca letras minúsculas
FROM 
	Invoice
--------------------------------------------
SELECT	
	BillingCity || " " || BillingAddress  -- Concatena colunas
FROM 
	Invoice
--------------------------------------------
SELECT	
	BillingCity,
	total
FROM 
	Invoice
Where
	total BETWEEN 5 AND 10		--Entre 5 e 10
--------------------------------------------
SELECT	
	BillingCity,
	total
FROM 
	Invoice
Where
	total IN (1.98, 3.96)  -- Exatamente 1.98 e 3.96
--------------------------------------------
SELECT	
	substr(BillingCity, 1, 3),  -- Corta a palavra pegando a letra 1 e indo até a 3   
	\*OBS: A CONTAGEM É A PARTIR DA PRIMEIRA LETRA DE CORTE ONDE ELA VALE 1, então se fosse 2, 3 o resultado ia ser ill, pois ia se pegar a posição 2 que é o i e ia andar 3 casas sendo que uma é o próprio i.*\
	total
FROM 
	Invoice
--------------------------------------------
SELECT	
	DATE(InvoiceDate),  -- Pega Apenas a data e não a hora junto
	total
FROM 
	Invoice
--------------------------------------------
SELECT
    InvoiceDate,
    BillingAddress,
    BillingCity,
    total,
    CASE		--Cria nova coluna cujo o resultado do if defini o campo dessa coluna para cada elemento
        WHEN total < 2.00 THEN 'Baseline Purchase'
        WHEN total BETWEEN 2.00 AND 6.99 THEN 'Purchase'
        WHEN total BETWEEN 7.00 AND 15.00 THEN 'Target Purchase'
        ELSE 'Top Performer'
    END AS PurchaseType
FROM
    Invoice
ORDER BY
    BillingCity;
--------------------------------------------
SELECT
    Invoice.CustomerId,
	Customer.CustomerId,
	Customer.FirstName,
	Customer.LastName,
	Invoice.BillingCity
FROM
    Invoice
INNER JOIN	-- Junta tabelas utilizando chave primaria de uma e chave estrangeira da outra.
	Customer
	ON Invoice.CustomerId = Customer.CustomerId
ORDER BY
    BillingCity;
--LEFT OUTER JOIN
--RIGHT OUTER JOIN
--------------------------------------------
SELECT
    BillingCity,
	AVG(total)  --Exibe a média
FROM
    Invoice
GROUP BY    -- Agrupa as cidades com mesmo nome em um unico campo para exibir a média individual delas
	BillingCity
ORDER BY
    BillingCity;
--------------------------------------------
SELECT
    BillingCity,
	AVG(total)
FROM
    Invoice
WHERE
	BillingCity like 'S%'
GROUP BY
	BillingCity
HAVING					--Utilizado como uma segundo WHERE. HAVING é um WHERE de processamento posteiror as WHERE
	BillingCity Like 'SA%'
ORDER BY
    BillingCity;
--------------------------------------------
SELECT
	InvoiceDate,
	BillingAddress,
	BillingCity,
	total
FROM
	Invoice
WHERE
	total <
	(select avg(total) from Invoice) /*SubConsultas, é uma consulta feito dentro de outra consulta, 
	geralmente utilizada para filtrar dados e utiliza-los no para gerar 
	resultados que se espera de uma outra consulta (usado no WHERE).*/
ORDER BY
	total DESC		
--------------------------------------------
SELECT
	strftime('%Y-%m-%d',InvoiceDate) --Formata a data da forma que achar melhor
FROM
	Invoice
--------------------------------------------
SELECT
	InvoiceDate,
	strftime('%Y-%m-%d','now') - strftime('%Y-%m-%d',InvoiceDate) 
	--Calcula a diferença dos anos hoje - data antiga
FROM
	Invoice
--------------------------------------------
SELECT
	length(BillingCity)  --Quantidade de caracteres no campo
FROM
	Invoice
--------------------------------------------
-- Utilizado em situações como de exemplo: Uma empreza quer saber quais discos não aparece nos faturamentos
-- Dessa forma o DISTINCT pode eliminar resultados repetidos e filtrar os que não (NOT IN) aparece no faturamento.
SELECT DISTINCT --Pega Resultados unicos EX: Tiver 1, 1, 1, 1. Ele vai pegar apenas um 1.
	CustomerId
FROM
	Invoice
--------------------------------------------
CREATE VIEW V_AVGForCity AS --Cria uma visualização mostrando sempre os dados recentes da consulta a baixo como nesse caso.
SELECT
	BillingCity AS Cidade,
	AVG(Total) AS MédiaPorCidade
FROM
	Invoice
GROUP BY
	Cidade
	
---

CREATE VIEW V_Tracks_InvoiceLine AS
SELECT
	il.InvoiceId,
	il.UnitPrice,
	il.Quantity,
	t.Name,
	t.Composer,
	t.Milliseconds
FROM
	InvoiceLine il
INNER JOIN
	Track t
ON
	t.TrackId = il.TrackId
--------------------------------------------
--Isso no SQLite
DROP VIEW IF EXISTS "main"."V_AVGForCity";   --Edita uma view existente primeiro, deleta depois cria novamente
CREATE VIEW V_AVGForCity AS
SELECT
	BillingCity AS Cidade,
	Round(AVG(Total),3) AS MédiaPorCidade --Editado colocando round 3
FROM
	Invoice
GROUP BY
	Cidade
--------------------------------------------
-- Exclui uma view
DROP VIEW IF EXISTS "main"."V_AVGForCity";
--OR
DROP VIEW"V_AVGForCity";
--------------------------------------------
INSERT INTO		--Insere dados no banco de dados
	Artist (Name)	--Especifíca a tabela e dentro do parenteses a coluna
VALUES ('Bob Marley')	--Nome do dado que deseja inserir
--Para inserir 2 ou mais dados
INSERT INTO
	Album (AlbumId, Title, ArtistId)
VALUES
	(12312, "SAMU", 4),
	(12323, "CAIO", 4)
--------------------------------------------
UPDATE		--Atualiza dados no banco de dados
	Artist	--Especifíca a tabela
SET Name = 'Damien Marley'  --Fala a coluna que se quer mudar junto com o novo para alterar
WHERE ArtistId = 276  --Utiliza o WHERE para saber onde vai ser alterar, qual a linha que a alteração vai ocorrer
--------------------------------------------
DELETE FROM		--Deleta os do banco de dados
	Artist	--Especifíca a tabela
WHERE
	ArtistId = 276	 --Utiliza o WHERE para saber onde vai ser Deletado

--------------------------------------------
--Uso de join com group by
/*Vamos preparar um relatório mostrando quantos membros de cada equipe vivem em cada região do país.
Nosso banco de dados do quiz contém duas tabelas, e pessoas*/
SELECT
	states.region,
	team,
	count(states.region)
FROM
	people
INNER JOIN
	states
ON
	people.state_code = states.state_abbrev
GROUP BY
	team,
	states.region
ORDER BY
	states.region;
-------------------------------------------
--Funções de Rankeamento Dense_Rank com over e partition by
/* Faz um rank com base na coluna especificada, dessa forma gera uma outra coluna mostrando o rank das pessoas que mais
venderam por exemplo, não deixa lacunas de ordem (1 , 1, 2). O partition By senve para separar os resultados por partições
especificadas pela coluna desejada.*/
Select 
	InvoiceId,
	BillingCity,
	total,
	dense_rank() over(PARTITION BY BillingCity order by total desc) AS Rank
FROM 
	Invoice
-------------------------------------------
--Funções de Rankeamento Rank com over
/* Faz um rank com base na coluna especificada, dessa forma gera uma outra coluna mostrando o rank das pessoas que mais
venderam por exemplo, deixa lacunas de ordem (1 , 1, 3). O partition By pode ser usado aqui também*/
Select 
	InvoiceId,
	total,
	Rank() over(order by total desc) AS Rank
FROM 
	Invoice
-------------------------------------------
/*Uma procedure (procedimento armazenado) é um bloco de código SQL 
armazenado no banco de dados que pode ser executado repetidamente.
É como uma função, mas geralmente usada para realizar operações no banco, 
como manipulação de dados ou execução de lógica complexa.  NÃO FAZ SQL, APENAS DML
MAIOR DESEMPENHO QUE A VIEW. MUDA DEPENDENDO DO BANCO A BAIXO É PARA POSTGRESS
As procedures armazenadas reduzem a quantidade de dados transmitidos pela rede, 
enviando apenas o nome da procedure e os parâmetros.*/

CREATE PROCEDURE inserir_dados(nome TEXT, salario NUMERIC)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO funcionarios (nome, salario)
    VALUES (nome, salario);
END;
$$;
-------------------------------------------
/*Um índice em SQL é uma estrutura de dados especial que o 
banco de dados cria para facilitar e acelerar o acesso a dados em uma tabela. 
Ele é semelhante a um índice de um livro, onde você pode rapidamente localizar 
um tópico específico sem precisar percorrer todas as páginas.
GERALMENTE USA BTREE PARA ACELERAR AS BUSCAS
o ganho pode variar de 70% a 99% em relação a uma busca sem índices.
Pode prejudicar o desmpenho do DML*/

Índice Simples
Cria um índice em uma única coluna:

CREATE INDEX idx_nome ON clientes(nome);
2. Índice Composto
Cria um índice que combina várias colunas:

CREATE INDEX idx_nome_email ON clientes(nome, email);
3. Índice Único (Unique Index)
Garante que os valores em uma coluna sejam únicos:

CREATE UNIQUE INDEX idx_unique_email ON clientes(email);
4. Índice Clustered
Disponível em sistemas como SQL Server. Ordena fisicamente os dados da tabela:

CREATE CLUSTERED INDEX idx_clustered_nome ON clientes(nome);
5. Índice de Texto Completo (Full-Text Index)
Usado para buscas avançadas em colunas de texto (disponível em MySQL e SQL Server):

CREATE FULLTEXT INDEX idx_fulltext_nome ON clientes(nome);
6. Índice com Condição (Partial Index)
Usado para criar índices em linhas específicas (suportado no PostgreSQL):

CREATE INDEX idx_active_clients ON clientes(nome) WHERE ativo = true;
7. Índice Único Composto
Combina várias colunas e garante unicidade:

CREATE UNIQUE INDEX idx_unique_nome_email ON clientes(nome, email);
8. Índice HASH
Usado para buscas de igualdade (aplicável em alguns SGBDs como PostgreSQL):

CREATE INDEX idx_hash_nome ON clientes USING HASH (nome);
9. Índice Descendente
Cria um índice ordenado de forma decrescente:

CREATE INDEX idx_desc_nome ON clientes(nome DESC);
10. Índice Espacial (Spatial Index)
Para operações geográficas (aplicável em MySQL e PostgreSQL com PostGIS):

CREATE SPATIAL INDEX idx_location ON locations(coordinates);

-------------------------------------------
/*Criando roles dentro do postgress usando sql*/
-- 1. Criar um role simples grupo
CREATE ROLE user1;

-- 2. Criar um role com login
CREATE ROLE user2 WITH LOGIN PASSWORD 'password123';

-- 3. Criar um role com permissões administrativas
CREATE ROLE admin_user WITH SUPERUSER CREATEDB CREATEROLE LOGIN PASSWORD 'admin@123';

-- 4. Criar um role com limite de conexões e validade
CREATE ROLE limited_user WITH LOGIN PASSWORD 'safePass@456' VALID UNTIL '2625-05-31' CONNECTION LIMIT 10;

-- 5. Criar um role apenas para criar bancos de dados
CREATE ROLE db_creator WITH CREATEDB LOGIN PASSWORD 'dbPass@789';

-- 6. Criar um role apenas para gerenciar outros roles
CREATE ROLE role_manager WITH CREATEROLE LOGIN PASSWORD 'manager@321';
-- Tipos de permissões para usuários do bd
SELECT
INSERT
UPDATE
DELETE
EXECUTE
CONNECT
CREATE
TEMPORARY / TEMP

-- Sintaxe para habilitar uma permissão 
GRANT  SELECT/INSERT/UPDATE... on Customer (TABELA ONDE A PERMISSÃO VAI SER CONSEDIDA) to Uriel (USUÁRIO DO BD QUE VAI RECEBER PERMISSÃO)
-- Para habilitar mais de uma simultanemanete
GRANT  SELECT, UPDATE on Customer (TABELA ONDE A PERMISSÃO VAI SER CONSEDIDA) to Uriel (USUÁRIO DO BD QUE VAI RECEBER PERMISSÃO)
-- Habilitar permissão para todas as tabelas de uma vez
grant select on all tables in schema public to uriel
-- Da também permissão para o usuário dar permissões de select para outros users
grant select on customer to johnl with grant option

-- Para retirar permissões
Revoke SELECT/INSERT/UPDATE... on Customer (TABELA ONDE VAI SER RETIRADO A PERMISSÃO) From Uriel (USUÁRIO DO BD QUE VAI SER RETIRADO A PERMISSÃO)
-- Retirar 2 permissões de uma vez
Revoke SELECT, UPDATE on Customer (TABELA ONDE VAI SER RETIRADO A PERMISSÃO) From Uriel (USUÁRIO DO BD QUE VAI SER RETIRADO A PERMISSÃO)
-- Usar ALL para tirar todas as permissões
Revoke ALL on Customer (TABELA ONDE VAI SER RETIRADO A PERMISSÃO) From Uriel (USUÁRIO DO BD QUE VAI SER RETIRADO A PERMISSÃO)

-- Criar hierarquias de roles
create role sales_manags in role sales_team