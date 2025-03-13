# Projeto de Gerenciamento de Dados e Informação

O projeto consiste em criar um banco de dados desde o projeto conceitual até o físico, tendo os seguintes requisitos para serem cumpridos

## Projeto Conceitual

- [x] Atributos
  - [x] Composto (**Endereço em Pessoa**: Atributo composto que representa o endereço completo de uma pessoa, incluindo rua, número, cidade, etc.)
  - [x] Multivalorado (**Telefones em Aluno**: Atributo que permite associar múltiplos números de telefone a um aluno.)
  - [x] Discriminador em relacionamento (**Discriminador da Monitoria**: Usado para distinguir diferentes tipos de monitoria dentro do relacionamento.)

- [x] Relacionamentos
  - [x] 1:1 (**Tem Cota**: A entidade associativa matricula pode ter uma cota e uma cota ser de uma matricula.)
  - [x] 1:N (**Feito Por**: Uma avaliação só pode ter sido feita por um aluno e um aluno pode fazer N avaliações.)
  - [x] N:M (**Monitora**: Um monitor pode monitorar N disciplinas e uma disciplina pode ter M monitores)
  - [x] Parcial-Total (**Monitora**: É obrigado para uma disciplina ter pelo menos 1 monitor para ser registrada.)
  - [x] Parcial-Parcial (**Requisito**: As disciplinas não precisam de uma disciplina de requisito para serem registradas.)
  - [x] Unário ou Auto-Relacionamento (**Requisito**: Entidade Disciplina possui outras disciplinas como requisito.)
  - [x] Identificador ou Entidade Fraca (**Avaliação**: Avaliação não pode existir sem um aluno.)
  - [x] Binário (**Monitora**: Relacionamento binário entre disciplina e monitor.)
  - [x] N-ário (**Assume**: Ternário que associa as entidades cargo, projeto e professor.)

- [x] Entidade Associativa (**Matricula**: Aluno pode se matricular em uma disciplina podendo ter cota ou não.)

- [x] Herança (qualquer tipo) (**Pessoa para os Outros**: Herança entre uma classe genérica "Pessoa" e suas especializações, como aluno, professor, etc.)

![Banco de Dados Conceitual](Projeto_Conceitual/Captura%20de%20tela%202025-03-06%20212700.png)

## Projeto Lógico

Não possui nenhum requisito

## Projeto Físico

- [x] Group by/Having
- [x] Junção interna
- [ ] Junção externa
- [ ] Semi junção
- [ ] Anti-junção
- [ ] Subconsultas
  - [ ] Escalar
  - [ ] Linha
  - [ ] Tabela
- [ ] Operação de conjunto

### Tipos de Dados
```sql
-- Tipo para endereço
CREATE OR REPLACE TYPE endereco_t AS OBJECT (
    rua VARCHAR2(50),
    cep VARCHAR2(8)
);
```

### Entidades
```sql
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

CREATE TABLE disciplina (
    id            INTEGER      PRIMARY KEY,
    nome          VARCHAR(30)  NOT NULL,
    carga_horaria NUMBER(3, 1) NOT NULL
);

CREATE TABLE cota (
    tipo INTEGER PRIMARY KEY
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
```

### Entidades Associativas

```sql

CREATE TABLE matricula (
    id_aluno      INTEGER,
    id_disciplina INTEGER,
    codigo        INTEGER NOT NULL,
    dt_matricula  DATE    NOT NULL,
    CONSTRAINT pk_matricula PRIMARY KEY (id_aluno, id_disciplina, codigo),
    CONSTRAINT fk_matricula_disciplina FOREIGN KEY (id_disciplina) REFERENCES disciplina (id),
    CONSTRAINT fk_matricula_aluno FOREIGN KEY (id_aluno) REFERENCES aluno (id)
);
```

### Relacionamentos

```sql
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

CREATE TABLE tem (
    tipo_cota    INTEGER,
    id_aluno      INTEGER,
    id_disciplina INTEGER,
    codigo        INTEGER NOT NULL,
    CONSTRAINT pk_tem PRIMARY KEY (tipo_cota, id_aluno, id_disciplina, codigo),
    CONSTRAINT fk_tem_cota FOREIGN KEY (tipo_cota) REFERENCES cota (tipo),
    CONSTRAINT fk_tem_matricula FOREIGN KEY (id_aluno, id_disciplina, codigo) REFERENCES matricula (id_aluno, id_disciplina, codigo)
);
```

### Atributos

```sql
-- Tabela de telefones (atributo multivalorado para a tabela aluno)
CREATE TABLE telefones (
    id_aluno    INTEGER,
    numero      VARCHAR2(11),
    CONSTRAINT fk_telefone_aluno FOREIGN KEY (id_aluno) REFERENCES aluno (id) ON DELETE CASCADE,
    CONSTRAINT pk_telefone_aluno PRIMARY KEY (id_aluno, numero)
);
```
