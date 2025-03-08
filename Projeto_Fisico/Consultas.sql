-- Consultando e agrupando por nome as disciplinas que possuem média de notas acima de 7
SELECT D.NOME, AVG(A.NOTA) FROM disciplina D INNER JOIN avaliacao A ON D.ID = A.ID_DISCIPLINA GROUP BY D.NOME HAVING AVG(A.NOTA) > 7;

-- Consulta os códigos dos projetos que um determinado professor ocupa com um determinado cargo
CREATE OR REPLACE PROCEDURE projetos_prof_cargo (prof_id INTEGER, cargo_cod INTEGER) IS
		CURSOR cur_proj IS SELECT codigo_projeto FROM assume where codigo_cargo = cargo_cod AND id_professor = prof_id;
		cod_proj projeto.codigo%TYPE;
	BEGIN
		OPEN cur_proj;
		LOOP
			FETCH cur_proj INTO cod_proj;
			EXIT WHEN cur_proj%NOTFOUND;
			DBMS_OUTPUT.PUT_LINE(cod_proj);
		END LOOP;
	END;

-- Apenas executa o procedimento acima para 1,1 deve mostrar no console 101 e para 2,2 deve mostrar 102
EXEC projetos_prof_cargo(2, 2);
