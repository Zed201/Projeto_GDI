-- Consultando e agrupando por nome as disciplinas que possuem média de notas acima de 7
SELECT D.NOME, AVG(A.NOTA) FROM disciplina D INNER JOIN avaliacao A ON D.ID = A.ID_DISCIPLINA GROUP BY D.NOME HAVING AVG(A.NOTA) > 7;
