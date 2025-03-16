# Consultas SQL

## Inner Join e Group by/Having

Consultando e agrupando por nome as disciplinas que possuem média de notas acima de 7

```sql
SELECT D.NOME,
       AVG(A.NOTA)
FROM DISCIPLINA D
INNER JOIN AVALIACAO A ON D.ID = A.ID_DISCIPLINA
GROUP BY D.NOME
HAVING AVG(A.NOTA) > 7;
```

```
+-------------------------+------------+
| NOME                    | AVG(A.NOTA)|
+-------------------------+------------+
| Química Geral           | 8          |
| Literatura Brasileira   | 9.5        |
| Física II               | 7.5        |
| Estatística             | 9          |
| Direito Constitucional  | 8.5        |
| Algoritmos              | 8.5        |
| Cálculo I               | 9          |
+-------------------------+------------+
```

## Junção externa

Alunos ainda sem prova e com inner join para ver o nome deles

```sql
SELECT AL.ID,
       AL.NOME
FROM
    (SELECT IA.ID,
            P.NOME
     FROM ALUNO IA
     INNER JOIN PESSOA P ON P.ID = IA.ID) AL
LEFT OUTER JOIN AVALIACAO AV ON AV.ID_ALUNO = AL.ID
WHERE AV.ID IS NULL;
```

```
+----+--------+
| ID | NOME   |
+----+--------+
| 6  | Robson |
+----+--------+
```

## Semi Junção

Selecionar as disciplinas com avaliação

```sql
SELECT *
FROM DISCIPLINA D
WHERE D.ID IN
        (SELECT A.ID_DISCIPLINA
         FROM AVALIACAO A);
```

```
+-----+-------------------------+--------------+
| ID  | NOME                    | CARGA_HORARIA |
+-----+-------------------------+--------------+
| 201 | Algoritmos              | 60           |
| 202 | Cálculo I               | 90           |
| 206 | Física II               | 75           |
| 204 | Química Geral           | 60           |
| 205 | Literatura Brasileira   | 45           |
| 208 | Direito Constitucional  | 90           |
| 209 | Psicologia Social       | 45           |
| 207 | Estatística             | 60           |
+-----+-------------------------+--------------+
```

## Group by

Retorna a quantidade de projetos por professor

```sql
SELECT P.ID,
       P.NOME,
       COUNT(S.ID_PROFESSOR) AS NUMERO_DE_PROJETOS
FROM PESSOA P
INNER JOIN ASSUME S ON P.ID = S.ID_PROFESSOR
GROUP BY P.NOME,
         P.ID;
```

```
+----+--------+-------------------+
| ID | NOME   | NUMERO_DE_PROJETOS |
+----+--------+-------------------+
| 1  | Carlos | 1                 |
| 2  | Ana    | 1                 |
| 7  | João   | 1                 |
| 8  | Maria  | 1                 |
| 9  | Pedro  | 1                 |
+----+--------+-------------------+
```

## Subconsulta do tipo escalar

Matricula mais recente

```sql
SELECT MAX(DT_MATRICULA) AS MATRICULA_RECENTE
FROM MATRICULA;
```

```
+----------------------+
| MATRICULA_RECENTE    |
+----------------------+
| 2024-02-08T00:00:00Z |
+----------------------+
```

## Subconsulta do tipo tabela

```sql
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
```

```
+----------+-----------+---------------+------+
| ID_ALUNO | NOME      | ID_DISCIPLINA | NOTA |
+----------+-----------+---------------+------+
| 4        | Mariana   | 201           | 8.5  |
| 5        | Fernanda  | 202           | 9    |
| 7        | João      | 206           | 7.5  |
| 8        | Maria     | 204           | 8    |
| 9        | Pedro     | 205           | 9.5  |
| 10       | Lucia     | 208           | 8.5  |
| 11       | Paulo     | 209           | 7    |
| 12       | Carla     | 207           | 9    |
+----------+-----------+---------------+------+
```

## Anti Join

Saber quais as disciplinas sem avaliações

```sql
SELECT D.NOME
FROM DISCIPLINA D
WHERE D.ID NOT IN
        (SELECT A.ID_DISCIPLINA
         FROM AVALIACAO A
         WHERE A.ID_DISCIPLINA IS NOT NULL);
```

```
+-----------------+
| NOME            |
+-----------------+
| F1(Física 1)    |
+-----------------+
```
