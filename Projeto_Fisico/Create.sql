-- Tipo para endereço
CREATE OR REPLACE TYPE endereco_t AS OBJECT (
    rua VARCHAR2(50),
    cep VARCHAR2(8)
);

CREATE TABLE pessoa (
    id        INTEGER     PRIMARY KEY,
    nome      VARCHAR(30) NOT NULL,
    sobrenome VARCHAR(30) NOT NULL,
    endereco  endereco_t
);

-- Tabela professor (subclasse de pessoa)
CREATE TABLE professor (
    id             INTEGER      PRIMARY KEY,
    especializacao VARCHAR(50),
    CONSTRAINT fk_professor_pessoa FOREIGN KEY (id) REFERENCES pessoa (id)
);

-- Tabela coordenador (subclasse de pessoa)
CREATE TABLE coordenador (
    id           INTEGER     PRIMARY KEY,
    departamento VARCHAR(30) NOT NULL,
    nome_curso   VARCHAR(30) NOT NULL,
    CONSTRAINT fk_coordenador_pessoa FOREIGN KEY (id) REFERENCES pessoa (id)
);

-- Tabela aluno (subclasse de pessoa)
CREATE TABLE aluno (
    id          INTEGER     PRIMARY KEY,
    curso_atual VARCHAR(30) NOT NULL,
    CONSTRAINT fk_aluno_pessoa FOREIGN KEY (id) REFERENCES pessoa (id)
);

-- Tabela de telefones (atributo multivalorado para a tabela aluno)
CREATE TABLE telefones (
    id_aluno    INTEGER,
    numero      VARCHAR2(11),
    CONSTRAINT fk_telefone_aluno FOREIGN KEY (id_aluno) REFERENCES aluno (id) ON DELETE CASCADE,
    CONSTRAINT pk_telefone_aluno PRIMARY KEY (id_aluno, numero)
);

-- Tabela monitor (Herda de pessoa)
CREATE TABLE monitor (
    id INTEGER PRIMARY KEY,
    CONSTRAINT fk_monitor_pessoa FOREIGN KEY (id) REFERENCES pessoa (id)
);

CREATE TABLE projeto (
    codigo INTEGER PRIMARY KEY
);

CREATE TABLE cargo (
    codigo    INTEGER      PRIMARY KEY,
    descricao VARCHAR(100)
);

-- Tabela Associativa assume (professor assume cargo em um Projeto)
CREATE TABLE assume (
    id_professor   INTEGER,
    codigo_projeto INTEGER,
    codigo_cargo   INTEGER NOT NULL,
    CONSTRAINT pk_assume PRIMARY KEY (id_professor, codigo_projeto),
    CONSTRAINT fk_assume_professor FOREIGN KEY (id_professor) REFERENCES professor (id) ON DELETE CASCADE,
    CONSTRAINT fk_assume_projeto FOREIGN KEY (codigo_projeto) REFERENCES projeto (codigo),
    CONSTRAINT fk_assume_cargo FOREIGN KEY (codigo_cargo) REFERENCES cargo (codigo)
);

CREATE TABLE disciplina (
    id            INTEGER      PRIMARY KEY,
    nome          VARCHAR(30)  NOT NULL,
    carga_horaria NUMBER(3, 1) NOT NULL
);

-- Tabela Associativa ensina (professor ensina disciplina)
CREATE TABLE ensina (
    id_professor INTEGER,
    id_disciplina INTEGER,
    CONSTRAINT pk_ensina PRIMARY KEY (id_professor, id_disciplina),
    CONSTRAINT fk_ensina_professor FOREIGN KEY (id_professor) REFERENCES professor (id),
    CONSTRAINT fk_ensina_disciplina FOREIGN KEY (id_disciplina) REFERENCES disciplina (id)
);

-- Tabela Associativa monitora (monitor monitora disciplina)
CREATE TABLE monitora (
    id_monitor INTEGER,
    id_disciplina INTEGER,
    discriminador VARCHAR(30),
    CONSTRAINT pk_monitora PRIMARY KEY (id_monitor, id_disciplina),
    CONSTRAINT fk_monitora_professor FOREIGN KEY (id_monitor) REFERENCES monitor (id),
    CONSTRAINT fk_monitora_disciplina FOREIGN KEY (id_disciplina) REFERENCES disciplina (id)
);

-- Tabela Associativa de Auto Relacionamento requisito (disciplina1 é requisito da disciplina2)
CREATE TABLE requisito (
    id_disciplina1 INTEGER,
    id_disciplina2 INTEGER,
    CONSTRAINT pk_requisito PRIMARY KEY (id_disciplina1, id_disciplina2),
    CONSTRAINT fk_requisito_disciplina1 FOREIGN KEY (id_disciplina1) REFERENCES disciplina (id),
    CONSTRAINT fk_requisito_disciplina2 FOREIGN KEY (id_disciplina2) REFERENCES disciplina (id)
);

CREATE TABLE matricula (
    id_aluno      INTEGER,
    id_disciplina INTEGER,
    codigo        INTEGER NOT NULL,
    dt_matricula  DATE    NOT NULL,
    CONSTRAINT pk_matricula PRIMARY KEY (id_aluno, id_disciplina, codigo),
    CONSTRAINT fk_matricula_disciplina FOREIGN KEY (id_disciplina) REFERENCES disciplina (id),
    CONSTRAINT fk_matricula_aluno FOREIGN KEY (id_aluno) REFERENCES aluno (id)
);

CREATE TABLE cota (
    tipo INTEGER PRIMARY KEY
);

CREATE TABLE tem (
    tipo_cota    INTEGER,
    id_aluno      INTEGER,
    id_disciplina INTEGER,
    codigo        INTEGER NOT NULL,
    CONSTRAINT pk_tem PRIMARY KEY (tipo_cota, id_aluno, id_disciplina, codigo),
    CONSTRAINT fk_tem_cota FOREIGN KEY (tipo_cota) REFERENCES cota (tipo),
    CONSTRAINT fk_tem_matricula FOREIGN KEY (id_aluno, id_disciplina, codigo) REFERENCES matricula (id_aluno, id_disciplina, codigo)
);

CREATE TABLE avaliacao (
    id_disciplina INTEGER,
    id_aluno      INTEGER,
    id            INTEGER      NOT NULL,
    tipo          VARCHAR(20),
    nota          NUMBER(3, 1) NOT NULL,
    CONSTRAINT pk_avaliacao PRIMARY KEY (id_disciplina, id_aluno, id),
    CONSTRAINT fk_avaliacao_disciplina FOREIGN KEY (id_disciplina) REFERENCES disciplina (id),
    CONSTRAINT fk_avaliacao_aluno FOREIGN KEY (id_aluno) REFERENCES aluno (id)
);
