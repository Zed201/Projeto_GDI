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

-- Juncao externa, alunos ainda sem prova e com inner join para ver o nome deles
SELECT AL.ID, AL.NOME FROM (
		SELECT IA.ID, P.NOME FROM ALUNO IA INNER JOIN PESSOA P ON P.ID = IA.ID
	) AL LEFT OUTER JOIN AVALIACAO AV ON AV.ID_ALUNO = AL.ID WHERE AV.ID IS NULL;


-- Semi Juncao, selecionar as disciplinas com avaliacao
SELECT * FROM DISCIPLINA D WHERE D.ID IN (SELECT A.ID_DISCIPLINA FROM AVALIACAO A);


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


-- Retorna a quantidade de projetos por professor
SELECT P.ID, P.NOME, COUNT(S.ID_PROFESSOR) AS NUMERO_DE_PROJETOS FROM 
PESSOA P INNER JOIN ASSUME S ON P.ID = S.ID_PROFESSOR
GROUP BY P.NOME, P.ID; 

-- Subconsulta do tipo escalar
SELECT MAX(DT_MATRICULA) AS MATRICULA_RECENTE FROM MATRICULA;

-- Subconsulta do tipo tabela
SELECT A.ID_ALUNO,(SELECT NOME FROM PESSOA WHERE ID = A.ID_ALUNO) AS NOME, A.ID_DISCIPLINA, A.NOTA FROM AVALIACAO A JOIN (
    SELECT ID_DISCIPLINA, MAX(NOTA) AS MAX_NOTA FROM AVALIACAO GROUP BY ID_DISCIPLINA
) ALIAS ON A.ID_DISCIPLINA = ALIAS.ID_DISCIPLINA AND A.NOTA = ALIAS.MAX_NOTA;

-- Atualiza os Valores de requisito
CREATE OR REPLACE PROCEDURE atualiza_requisito(
    ID_1_OLD IN NUMBER,
    ID_2_OLD IN NUMBER,
    ID_1_NEW IN NUMBER,
    ID_2_NEW IN NUMBER 
)
IS
    Cont1 NUMBER := 0;
    Cont2 NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO Cont1 FROM DISCIPLINA WHERE ID = ID_1_NEW;
    SELECT COUNT(*) INTO Cont2 FROM DISCIPLINA WHERE ID = ID_2_NEW;
    IF Cont1 > 0 AND Cont2 > 0 THEN
        UPDATE REQUISITO
        SET ID_DISCIPLINA1 = ID_1_NEW, ID_DISCIPLINA2 = ID_2_NEW
        WHERE ID_DISCIPLINA1 = ID_1_OLD AND ID_DISCIPLINA2 = ID_2_OLD;
        COMMIT;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Alguma DISCIPLINA NÃO está cadastrada!');
    END IF;
END atualiza_requisito;
