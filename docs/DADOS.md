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

## Tratamento dos Dados

Vi um erro nos dados: existem dados outliers que saem do padrão da tabela. Por facilidade os outliers não serão constado nas contas SQL, porém não serão deletados do banco de dados pois pode ser erro de digitação do usuário e podem ser manualmente reescritos depois em ambiente de produção ou desenvolvimento que permitam editar os atestados. Não sei se é real manter os dados outliers em ambiente de produção, mas para este desafio vou optar por manter os dados íntegros.

### Custo de Afastamento

- O custo de afastamento tem dados com "--" e vazio / NULL. Ambos serão tratados como custo 0. Entram na conta de custo do departamento mas não interferem no resultado final.

### Código

- O código não apresenta problemas. Cada código é composto de 7 dígitos e não apresenta tratamento evidente especial. Código será tratado como o código do atestado.

### Identificação

- A identificação é uma repetição desnecessária. Poderia ser a identificação do atestado mas não está explícito. Será tratado como identificação de usuário, mas mais como uma salvaguarda. Tipo varchar / String para comportar a maioria dos casos de id, mas todos registros nulos. Quando for vazio será uma string vazia.

### Funcionário

- Será tratado como String / varchar. Em caso de vazio será "". Composta de "Anonimo" + <int>.

### Departamento

- Não tem nomes claros. Ex: departamento Gerente. Será colocado o nome do departamento como tal para não gerar discussões posteriores. As vezes o nome dos departamentos é esse para melhor entendimento de quem já trabalha. Poderia muito bem colocar TECNICO SEGUROS IV com TECNICO SEGUROS II, mas pode ser que sejam departamentos diferentes então vou ignorar. Em caso de espaços vazios o departamento não pode ser contabilizado na query de gasto por departamento. Entretanto ela terá espaço no banco mas não será contabilizada na query.

### Data do Atestado

- Um atestado tem de ter uma data. Um atestado sem data não é válido neste programa. Sem data ele não é válido para uma empresa. Registro sem data não serão salvos. Datas devem ser válidas obviamente.

### Especialidade

- Será tratado como String / varchar. Em caso de vazio será "".

### Especialidade

- Será tratado como String / varchar. Em caso de vazio será "".

### Outlier de Custo (regra formalizada)

A regra usada para identificar os outliers mencionados acima: um atestado é
outlier de custo quando seu `custo_afastamento` é mais de 10x a mediana dos
próprios custos (> 0) do mesmo funcionário, exigindo pelo menos 2 atestados com
custo > 0 desse funcionário para ter uma base de comparação (funcionário com só 1
atestado nunca pode ser marcado, não há linha de base pra comparar).

Testado outlier estatístico *global* (IQR e z-score, com e sem excluir zeros, em
escala normal e logarítmica) contra os 91 registros do CSV antes de chegar nessa
regra: todos marcavam entre 13 e 21 linhas, incluindo clusters de custo legítimos
e recorrentes (ex: `310` aparece 9 vezes para o mesmo contexto). A regra por
funcionário evita esse problema porque compara cada atestado só com o histórico do
próprio funcionário, não com a distribuição inteira do dataset.

Validado contra os dados reais: a regra marca exatamente 1 linha (código
`1027601`, `Anonimo 15`, custo `9215` vs mediana pessoal `92,15`).

O outlier é mantido na tabela `atestado` (coluna `custo_outlier`), nunca deletado.
Só é excluído das perguntas de gasto (departamento/líder que mais gastou); nas
perguntas de contagem de ocorrências ele continua contando normalmente.

Nota: como a mediana inclui o próprio valor testado, o gatilho de fato só é
confiável a partir de 3 atestados com custo > 0 do mesmo funcionário — com
exatamente 2, um valor 100x maior desloca a própria mediana e pode não ser
detectado. Não afeta o dataset atual (validado sem lacunas).
