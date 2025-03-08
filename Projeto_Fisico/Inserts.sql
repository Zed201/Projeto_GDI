INSERT INTO pessoa (id, nome, sobrenome, endereco)
VALUES (1, 'Carlos', 'Silva', endereco_t('Rua A', '12345678')),
       (2, 'Ana', 'Souza', endereco_t('Rua B', '87654321')),
       (3, 'Roberto', 'Oliveira', endereco_t('Rua C', '11223344')),
       (4, 'Mariana', 'Pereira', endereco_t('Rua D', '44332211')),
       (5, 'Fernanda', 'Almeida', endereco_t('Rua E', '55667788')),
       (6, 'Robson', 'Fidalgo', endereco_t('Rua C', '34123354'));

-- Inserindo professores
INSERT INTO professor (id, especializacao)
VALUES (1, 'Matemática'),
       (2, 'Computação');

-- Inserindo coordenadores
INSERT INTO coordenador (id, departamento, nome_curso)
VALUES (3, 'Engenharia', 'Engenharia Civil');

-- Inserindo alunos
INSERT INTO aluno (id, curso_atual)
VALUES (4, 'Ciência da Computação'),
       (5, 'Engenharia Elétrica'),
       (6, 'Teatro');

-- Inserindo telefones para alunos
INSERT INTO telefones (id_aluno, numero)
VALUES (4, '11999998888'),
       (4, '11988887777'),
       (5, '11977776666');

-- Inserindo monitores
INSERT INTO monitor (id)
VALUES (4);

-- Inserindo projetos
INSERT INTO projeto (codigo)
VALUES (101),
       (102);

-- Inserindo cargos
INSERT INTO cargo (codigo, descricao)
VALUES (1, 'Coordenador de Projeto'),
       (2, 'Pesquisador');

-- Associando professores a projetos e cargos
INSERT INTO assume (id_professor, codigo_projeto, codigo_cargo)
VALUES (1, 101, 1),
       (2, 102, 2);

-- Inserindo disciplinas
INSERT INTO disciplina (id, nome, carga_horaria)
VALUES (201, 'Algoritmos', 60),
       (202, 'Cálculo I', 90),
       (203, 'F1(Física 1)', 75);

-- Associando professores a disciplinas
INSERT INTO ensina (id_professor, id_disciplina)
VALUES (1, 202),
       (2, 201);

-- Associando monitores a disciplinas
INSERT INTO monitora (id_monitor, id_disciplina, discriminador)
VALUES (4, 201, 'Laboratório');

-- Criando pré-requisitos para disciplinas
INSERT INTO requisito (id_disciplina1, id_disciplina2)
VALUES (201, 202);  -- Algoritmos é pré-requisito de Cálculo I

-- Matriculando alunos em disciplinas
INSERT INTO matricula (id_aluno, id_disciplina, codigo, dt_matricula)
VALUES (4, 201, 1, TO_DATE('2024-02-01', 'YYYY-MM-DD')),
       (5, 202, 2, TO_DATE('2024-02-02', 'YYYY-MM-DD'));

-- Inserindo cotas
INSERT INTO cota (tipo)
VALUES (1),
       (2);

-- Associando cotas a alunos matriculados
INSERT INTO tem (tipo_cota, id_aluno, id_disciplina, codigo)
VALUES (1, 4, 201, 1),
       (2, 5, 202, 2);

-- Inserindo avaliações
INSERT INTO avaliacao (id_disciplina, id_aluno, id, tipo, nota)
VALUES (201, 4, 1, 'Prova', 8.5),
       (202, 5, 1, 'Trabalho', 9.0);
