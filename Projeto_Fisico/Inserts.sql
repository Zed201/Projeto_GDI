INSERT INTO pessoa (id, nome, sobrenome, endereco)
VALUES (1, 'Carlos', 'Silva', endereco_t('Rua A', '12345678')),
       (2, 'Ana', 'Souza', endereco_t('Rua B', '87654321')),
       (3, 'Roberto', 'Oliveira', endereco_t('Rua C', '11223344')),
       (4, 'Mariana', 'Pereira', endereco_t('Rua D', '44332211')),
       (5, 'Fernanda', 'Almeida', endereco_t('Rua E', '55667788')),
       (6, 'Robson', 'Fidalgo', endereco_t('Rua C', '34123354')),
       (7, 'João', 'Santos', endereco_t('Rua F', '99887766')),
       (8, 'Maria', 'Fernandes', endereco_t('Rua G', '88776655')),
       (9, 'Pedro', 'Costa', endereco_t('Rua H', '77665544')),
       (10, 'Lucia', 'Martins', endereco_t('Rua I', '66554433')),
       (11, 'Paulo', 'Rocha', endereco_t('Rua J', '55443322')),
       (12, 'Carla', 'Lima', endereco_t('Rua K', '44332211'));

-- Inserindo professores
INSERT INTO professor (id, especializacao)
VALUES (1, 'Matemática'),
       (2, 'Computação'),
       (7, 'Física'),
       (8, 'Química');       

-- Inserindo coordenadores
INSERT INTO coordenador (id, departamento, nome_curso)
VALUES (3, 'Engenharia', 'Engenharia Civil');


-- Inserindo alunos
INSERT INTO aluno (id, curso_atual)
VALUES 	(6, 'Engenharia'),
	(9,'Medicina'),
       (10, 'Direito'),
       (11, 'Arquitetura'),
       (12, 'Psicologia');

-- Inserindo telefones para alunos
INSERT INTO telefones (id_aluno, numero)
VALUES (9, '11944443333'),
       (10, '11933332222'),
       (11, '11922221111'),
       (12, '11911110000');

-- Inserindo monitores
INSERT INTO monitor (id)
VALUES (4),
       (5),
       (6);
       
       
-- Inserindo projetos
INSERT INTO projeto (codigo)
VALUES (101),
       (102),
       (103),
       (104),
       (105);

-- Inserindo cargos
INSERT INTO cargo (codigo, descricao)
VALUES (1, 'Coordenador de Projeto'),
       (2, 'Pesquisador'),
       (3, 'Analista de Dados'),
       (4, 'Desenvolvedor'),
       (5, 'Consultor');

-- Associando professores a projetos e cargos
INSERT INTO assume (id_professor, codigo_projeto, codigo_cargo)
VALUES (1, 101, 1),
       (2, 102, 2),
       (7, 103, 3),
       (8, 104, 4);

-- Inserindo disciplinas
INSERT INTO disciplina (id, nome, carga_horaria)
VALUES (201, 'Algoritmos', 60),
       (202, 'Cálculo I', 90),
       (203, 'F1(Física 1)', 75),
       (204, 'Química Geral', 60),
       (205, 'Literatura Brasileira', 45),
       (206, 'Física II', 75),
       (207, 'Estatística', 60),
       (208, 'Direito Constitucional', 90),
       (209, 'Psicologia Social', 45);

-- Associando professores a disciplinas
INSERT INTO ensina (id_professor, id_disciplina)
VALUES (1, 202),
       (2, 201);

INSERT INTO monitora (id_monitor, id_disciplina, discriminador)
VALUES (5, 202, 'Teoria'),
       (4, 201, 'Laboratório');

-- Criando pré-requisitos para disciplinas
INSERT INTO requisito (id_disciplina1, id_disciplina2)
VALUES (201, 202),  -- Algoritmos é pré-requisito de Cálculo I
       (202, 206),  -- Cálculo I é pré-requisito de Física II
       (204, 207);  -- Química Geral é pré-requisito de Estatística

-- Matriculando alunos em disciplinas
INSERT INTO matricula (id_aluno, id_disciplina, codigo, dt_matricula)
VALUES (9, 205, TO_DATE('2024-02-05', 'YYYY-MM-DD')),
       (10, 208, TO_DATE('2024-02-06', 'YYYY-MM-DD')),
       (11, 209, TO_DATE('2024-02-07', 'YYYY-MM-DD')),
       (12, 207, TO_DATE('2024-02-08', 'YYYY-MM-DD'));


-- Inserindo cotas
INSERT INTO cota (tipo, id_aluno, id_disciplina)
VALUES (5, 9, 205),
       (6, 10, 208),
       (7, 11, 209),
       (8, 12, 207);
       

-- Inserindo avaliações
INSERT INTO avaliacao (id_disciplina, id_aluno, id, tipo, nota)
VALUES (205, 9, 2, 'Seminário', 9.5),
       (208, 10, 2, 'Prova', 8.5),
       (209, 11, 2, 'Trabalho', 7.0),
       (207, 12, 2, 'Prova', 9.0);

