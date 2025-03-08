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


-- Alunos com avalicacao de qual disciplica e qual nota
SELECT A.NOME, AV.TIPO, AV.NOTA, AV.NOME_DISCIPLINA FROM (
    SELECT IA.ID, P.NOME FROM ALUNO IA INNER JOIN PESSOA P ON P.ID = IA.ID
) A INNER JOIN (
    SELECT AVI.ID_ALUNO, AVI.NOTA, AVI.TIPO, D.NOME AS NOME_DISCIPLINA FROM AVALIACAO AVI INNER JOIN DISCIPLINA D ON AVI.ID_DISCIPLINA = D.ID
) AV ON A.ID = AV.ID_ALUNO;


-- Juncao externa, alunos ainda sem prova e com inner join para ver o nome deles
SELECT AL.ID, AL.NOME FROM (
		SELECT IA.ID, P.NOME FROM ALUNO IA INNER JOIN PESSOA P ON P.ID = IA.ID
	) AL LEFT OUTER JOIN AVALIACAO AV ON AV.ID_ALUNO = AL.ID WHERE AV.ID IS NULL;


-- Semi Juncao, selecionar as disciplinas sem avaliacao
SELECT * FROM DISCIPLINA D WHERE D.ID NOT IN (SELECT A.ID_DISCIPLINA FROM AVALIACAO A);


-- Trigger de mundaça de professor que ensina disciplina
CREATE OR REPLACE TRIGGER Novo_prof_disciplina
BEFORE UPDATE OF ID_PROFESSOR ON ENSINA 
FOR EACH ROW
DECLARE
    DI DISCIPLINA.NOME%TYPE;
    NOME PESSOA.NOME%TYPE;
BEGIN
    SELECT D.NOME INTO DI FROM DISCIPLINA D WHERE D.ID = :NEW.ID_DISCIPLINA;
    SELECT P.NOME INTO NOME FROM PESSOA P WHERE :NEW.ID_PROFESSOR = P.ID;
    IF (:NEW.ID_PROFESSOR <> :OLD.ID_PROFESSOR) THEN
        DBMS_OUTPUT.PUT_LINE('Disciplina de ' || DI || ' com novo prof ' || NOME );
    END IF;
END;