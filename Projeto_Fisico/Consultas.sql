-- Consultando e agrupando por nome as disciplinas que possuem média de notas acima de 7

SELECT D.NOME,
       AVG(A.NOTA)
FROM DISCIPLINA D
INNER JOIN AVALIACAO A ON D.ID = A.ID_DISCIPLINA
GROUP BY D.NOME
HAVING AVG(A.NOTA) > 7;

-- Consultando todos os monitores que são exclusivos do professor 2

SELECT m.id_monitor
FROM monitora m
GROUP BY m.id_monitor
HAVING COUNT(*) = COUNT(
    CASE WHEN m.id_disciplina IN (
            SELECT id_disciplina FROM ensina
            GROUP BY id_disciplina
            HAVING COUNT(id_professor) = 1
            AND MIN(id_professor) = 2
            )
    THEN 1 
    END);

-- Consultando os professores e seus monitores exclusivos

SELECT E.ID_PROFESSOR, M.ID_MONITOR 
FROM ENSINA E INNER JOIN MONITORA M ON E.ID_DISCIPLINA = M.ID_DISCIPLINA 
WHERE M.ID_MONITOR IN (
    SELECT m1.id_monitor
    FROM monitora m1
    GROUP BY m1.id_monitor
    HAVING COUNT(*) = COUNT(
        CASE WHEN m1.id_disciplina IN (
                SELECT id_disciplina FROM ensina
                GROUP BY id_disciplina
                HAVING COUNT(id_professor) = 1
                AND MIN(id_professor) = E.ID_PROFESSOR
                )
        THEN 1 
        END)
);

-- Juncao externa, alunos ainda sem prova e com inner join para ver o nome deles

SELECT AL.ID,
       AL.NOME
FROM
    (SELECT IA.ID,
            P.NOME
     FROM ALUNO IA
     INNER JOIN PESSOA P ON P.ID = IA.ID) AL
LEFT OUTER JOIN AVALIACAO AV ON AV.ID_ALUNO = AL.ID
WHERE AV.ID IS NULL;

-- Semi Juncao, selecionar as disciplinas com avaliacao

SELECT *
FROM DISCIPLINA D
WHERE D.ID IN
        (SELECT A.ID_DISCIPLINA
         FROM AVALIACAO A);

-- Retorna a quantidade de projetos por professor

SELECT P.ID,
       P.NOME,
       COUNT(S.ID_PROFESSOR) AS NUMERO_DE_PROJETOS
FROM PESSOA P
INNER JOIN ASSUME S ON P.ID = S.ID_PROFESSOR
GROUP BY P.NOME,
         P.ID;

-- Subconsulta do tipo escalar

SELECT M.DT_MATRICULA FROM MATRICULA M WHERE M.DT_MATRICULA > (SELECT MIN(M2.DT_MATRICULA) FROM MATRICULA M2);

-- Subconsulta do tipo tabela

SELECT A.ID_ALUNO,

    (SELECT NOME
     FROM PESSOA
     WHERE ID = A.ID_ALUNO) AS NOME,
       A.ID_DISCIPLINA,
       A.NOTA
FROM AVALIACAO A
JOIN
    (SELECT ID_DISCIPLINA,
            MAX(NOTA) AS MAX_NOTA
     FROM AVALIACAO
     GROUP BY ID_DISCIPLINA) ALIAS ON A.ID_DISCIPLINA = ALIAS.ID_DISCIPLINA
AND A.NOTA = ALIAS.MAX_NOTA;

-- Anti Join (Saber quais as disciplinas sem avaliações)

SELECT D.NOME
FROM DISCIPLINA D
WHERE D.ID NOT IN
        (SELECT A.ID_DISCIPLINA
         FROM AVALIACAO A);


-- Union
/*LISTAR ALUNOS E PROFESSORES  POR UNIÃO */
SELECT U.ID, U.TIPO, P.NOME 
FROM (
    SELECT ID, 'ALUNO' AS TIPO FROM ALUNO
    UNION 
    SELECT ID, 'PROFESSOR' AS TIPO FROM PROFESSOR
) U
INNER JOIN PESSOA P ON U.ID = P.ID ORDER BY ID;


-- Intersect
/*PESSOAS QUE SÃO ALUNOS E PROFESSORES POR INTERSECÇÃO, NAO RETORNA NADA POIS A HERANÇA DEVE SER DISJOINT  */

SELECT ID 
FROM ALUNO 
INTERSECT
SELECT ID 
FROM PROFESSOR;


/*ALUNOS QUE NÃO SÃO PROFESSORES COM EXCEPT (ALUNOS QUE NÃO ESTÃO NA TABELA PROFESSOR), MESMA COISA QUE SELECT * FROM ALUNOS, POIS A HERANÇA É DISJOIN */

SELECT P.ID, P.NOME, P.SOBRENOME FROM (
SELECT ID 
FROM ALUNO 
    EXCEPT
SELECT ID
FROM PROFESSOR) U INNER JOIN PESSOA P ON (P.ID = U.ID);

/*ALUNOS QUE NÃO SÃO PROFESSORES COM LEFT JOIN + IS NULL MESMA COISA DO COMANDO ACIMA  */
SELECT A.ID
FROM ALUNO A  LEFT JOIN PROFESSOR P ON A.ID = P.ID
WHERE P.ID IS NULL; 


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- PL

-- Procedure de Subconsulta tipo linha (Saber os id dos coordenadores que tem o mesmo departamento e curso)

CREATE OR REPLACE PROCEDURE COORD_DEP_E_CURSO (COORD_ID INTEGER) IS
CURSOR CUR_COORDENADORES IS
SELECT C.ID
FROM COORDENADOR C
WHERE (C.DEPARTAMENTO,
       C.NOME_CURSO) =
        (SELECT C2.DEPARTAMENTO,
                C2.NOME_CURSO
         FROM COORDENADOR C2
         WHERE C2.ID = COORD_ID);

BEGIN
	FOR REC IN CUR_COORDENADORES LOOP 
		DBMS_OUTPUT.PUT_LINE('ID: ' || REC.ID);
	END LOOP;
END;

EXEC COORD_DEP_E_CURSO(3); -- Retorna so o id 3

-- Consulta os códigos dos projetos que um determinado professor ocupa com um determinado cargo

CREATE OR REPLACE PROCEDURE PROJETOS_PROF_CARGO (PROF_ID INTEGER, CARGO_COD INTEGER) IS
	CURSOR CUR_PROJ IS
		SELECT CODIGO_PROJETO
		FROM ASSUME
		WHERE CODIGO_CARGO = CARGO_COD
		    AND ID_PROFESSOR = PROF_ID;

	COD_PROJ PROJETO.CODIGO%TYPE;

BEGIN 
	OPEN CUR_PROJ;

	LOOP 
		FETCH CUR_PROJ INTO COD_PROJ;
	
		EXIT WHEN CUR_PROJ%NOTFOUND;
		
		DBMS_OUTPUT.PUT_LINE(COD_PROJ);
	END LOOP;
	CLOSE CUR_PROJ;
END;

-- Apenas executa o procedimento acima para 1,1 deve mostrar no console 101 e para 2,2 deve mostrar 102
EXEC PROJETOS_PROF_CARGO(1, 1);

EXEC PROJETOS_PROF_CARGO(2, 2);

-- Atualiza os Valores de requisito

CREATE OR REPLACE PROCEDURE ATUALIZA_REQUISITO(ID_1_OLD IN NUMBER, ID_2_OLD IN NUMBER, ID_1_NEW IN NUMBER, ID_2_NEW IN NUMBER) IS 

	CONT1 NUMBER := 0;
	CONT2 NUMBER := 0;

BEGIN
	SELECT COUNT(*) INTO CONT1
	FROM DISCIPLINA
	WHERE ID = ID_1_NEW;
	
	
	SELECT COUNT(*) INTO CONT2
	FROM DISCIPLINA
	WHERE ID = ID_2_NEW;
	
	IF CONT1 > 0
		AND CONT2 > 0 THEN
		UPDATE REQUISITO
		SET ID_DISCIPLINA1 = ID_1_NEW,
		    ID_DISCIPLINA2 = ID_2_NEW
		WHERE ID_DISCIPLINA1 = ID_1_OLD
		    AND ID_DISCIPLINA2 = ID_2_OLD;
			
		COMMIT;
		
		ELSE DBMS_OUTPUT.PUT_LINE('Alguma DISCIPLINA NÃO está cadastrada!');
	
	END IF;

END ATUALIZA_REQUISITO;

-- Trigger de mundaça de professor que ensina disciplina

CREATE OR REPLACE TRIGGER NOVO_PROF_DISCIPLINA
BEFORE
UPDATE OF ID_PROFESSOR ON ENSINA
FOR EACH ROW 
DECLARE 
	DI DISCIPLINA.NOME%TYPE; 
	NOME PESSOA.NOME%TYPE; 
BEGIN
	SELECT D.NOME INTO DI
	FROM DISCIPLINA D
	WHERE D.ID = :NEW.ID_DISCIPLINA;
	
	SELECT P.NOME INTO NOME
	FROM PESSOA P
	WHERE :NEW.ID_PROFESSOR = P.ID; 
	
	IF (:NEW.ID_PROFESSOR <> :OLD.ID_PROFESSOR) THEN 
		DBMS_OUTPUT.PUT_LINE('Disciplina de ' || DI || ' com novo prof ' || NOME); 
	END IF; 
END;
