# Dados

Os dados estão não tratados no início. É necessário saber os tipos para tratamento e como devem ser organizados. Atualmente as colunas e os tipos dos dados do .csv são os seguintes:

## Colunas / Tipo

| Coluna               | Tipo                                                                                                                                                                                                                                                                                                                                                                                    |
| -------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Código               | Integer                                                                                                                                                                                                                                                                                                                                                                                 |
| Custo do Afastamento | Float / Double                                                                                                                                                                                                                                                                                                                                                                          |
| Identificação        | String                                                                                                                                                                                                                                                                                                                                                                                  |
| Funcionário          | "Anonimo" + String / varchar                                                                                                                                                                                                                                                                                                                                                            |
| Departamento         | enum["Gerente", "ASSISTENTE DE IMPLANTACAO", "TECNICO SEGUROS IV", "TECNICO SEGUROS II", "ANALISTA CONTROLE OPERACIONAL I", "ASSISTENTE OPERACIONAL II", "TECNICO SEGUROS VG I", "ANALISTA INFORMACOES GERENCIAIS II", "TECNICO SEGUROS I", " ANALISTA INFORMACOES GERENCIAIS II", "ASSISTENTE OPERACIONAL I", "ASSISTENTE CONTROLE OPERACIONAL", "ANALISTA ESTUDOS E COTACAO II", ...] |
| Data do Atestado     | Date                                                                                                                                                                                                                                                                                                                                                                                    |
| Especialidade        | enum["Exames", "Neurologia", "Pediatria", "Neurologia", "Odontologia", "Dermatologia", "Nutrólogo", ...]                                                                                                                                                                                                                                                                                |
| Motivo               | enum["Consultas médicas", "Exames", ...]                                                                                                                                                                                                                                                                                                                                                |
| Líder                | enum["Sim", NULL]                                                                                                                                                                                                                                                                                                                                                                       |

### Custo de Afastamento

O custo de afastamento tem dados com "--" e vazio / NULL. Ambos serão tratados como custo 0. Entram na conta de custo do departamento mas não interferem no resultado final.

### Código

O código não apresenta problemas. Cada código é composto de 7 dígitos e não apresenta tratamento evidente especial. Código será tratado como o código do atestado.

### Identificação

A identificação é uma repetição desnecessária. Poderia ser a identificação do atestado mas não está explícito. Será tratado como identificação de usuário, mas mais como uma salvaguarda. Tipo varchar / String para comportar a maioria dos casos de id, mas todos registros nulos. Quando for vazio será uma string vazia.

### Funcionário

Será tratado como String / varchar. Em caso de vazio será "". Composta de "Anonimo" + <int>.

### Departamento

Não tem nomes claros. Ex: departamento Gerente. Será colocado o nome do departamento como tal para não gerar discussões posteriores. As vezes o nome dos departamentos é esse para melhor entendimento de quem já trabalha. Poderia muito bem colocar TECNICO SEGUROS IV com TECNICO SEGUROS II, mas pode ser que sejam departamentos diferentes então vou ignorar. Em caso de espaços vazios o departamento não pode ser contabilizado na query de gasto por departamento. Entretanto ela terá espaço no banco mas não será contabilizada na query.

### Data do Atestado

Um atestado tem de ter uma data. Um atestado sem data não é válido neste programa. Sem data ele não é válido para uma empresa. Registro sem data não serão salvos. Datas devem ser válidas obviamente.

### Especialidade

Será tratado como String / varchar. Em caso de vazio será "".

### Especialidade

Será tratado como String / varchar. Em caso de vazio será "".
