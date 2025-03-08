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
