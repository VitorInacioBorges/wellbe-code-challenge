# Execução

Passo a passo para rodar o projeto do zero, partindo de uma instância MySQL/MariaDB
local **vazia** (sem o banco `wellbe_desafio` pré-existente).

Todos os comandos abaixo foram executados literalmente, nesta ordem, em uma validação
do zero (drop do banco, recriação do schema, reexecução completa do notebook e
regeneração do dump) — ver a seção **Validação** no final. Ambiente usado nessa
validação: Windows 11, Git Bash, MariaDB 10.4.32 via XAMPP em `127.0.0.1:3306`
(usuário `root`, sem senha), repositório em disco no WSL acessado a partir do
Windows (`\\wsl.localhost\...`).

## 1. Pré-requisitos

- Python 3.11+ (validado com Python 3.14.3)
- MySQL 8.0+ ou MariaDB 10.2+ (as queries usam `WITH`/CTE) rodando localmente e
  acessível (ver links de instalação no PDF do desafio: XAMPP no Windows, LAMP
  no Ubuntu). Se estiver usando XAMPP no Windows e o MySQL não estiver rodando:
  `C:\xampp\mysql_start.bat`.
- **PATH do `mysql`/`mysqldump`:** no Windows, o instalador do XAMPP não coloca
  `mysql.exe`/`mysqldump.exe` no PATH por padrão. Os comandos deste documento
  assumem que você vai chamá-los pelo caminho completo da sua instalação (ex.:
  `C:\xampp\mysql\bin\mysql.exe`) ou que você adicionou `mysql\bin` ao PATH — os
  exemplos abaixo usam apenas `mysql`/`mysqldump`, mas substitua pelo caminho
  completo se eles não estiverem no seu PATH. Em LAMP (Ubuntu) eles normalmente
  já ficam no PATH depois do `apt install`.

## 2. Ambiente Python

O diretório `venv/` está no `.gitignore` (cada máquina cria o seu; nada dentro
dele é versionado). Crie e ative uma venv nova:

```bash
python -m venv venv
source venv/Scripts/activate   # Git Bash no Windows.
# PowerShell: venv\Scripts\Activate.ps1     cmd: venv\Scripts\activate.bat
# Linux/WSL nativo: source venv/bin/activate
pip install -r requirements.txt
```

Confirme que a venv está realmente isolada antes de seguir:

```bash
which python
# deve apontar para DENTRO de venv/ (ex.: venv/Scripts/python no Windows,
# venv/bin/python no Linux) — nunca para o Python do sistema.
```

> **Nota sobre WSL + Windows:** se o repositório mora no filesystem do WSL mas é
> acessado por ferramentas Windows nativas via `\\wsl.localhost\...` (como
> Git Bash/PowerShell do Windows), crie a venv com um Python **Windows nativo**
> (ex.: `C:\Python314\python.exe`), não com o Python do WSL. Uma venv Linux
> criada dentro do WSL usa symlinks (`venv/bin/python` → `/usr/bin/python3...`)
> que ficam ilegíveis/corrompidos quando acessados do lado Windows, mesmo que a
> venv esteja perfeitamente íntegra se acessada de dentro do próprio WSL. Um
> Python Windows nativo cria `venv/Scripts/python.exe` como binário real (sem
> symlink), que funciona nos dois lados.

## 3. Configuração do banco

```bash
cp .env.example .env
# edite .env com usuário/senha do seu MySQL local
```

Confirme que o banco ainda não existe:

```bash
mysql -h 127.0.0.1 -u root -p -e "SHOW DATABASES LIKE 'wellbe_desafio';"
```

Deve retornar vazio. Se já existir de uma execução anterior e você quiser
recomeçar do zero:

```bash
mysql -h 127.0.0.1 -u root -p -e "DROP DATABASE IF EXISTS wellbe_desafio;"
```

(No ambiente de validação, o MySQL local não tem senha, então os comandos
foram rodados sem `-p`; ajuste conforme a configuração do seu MySQL.)

## 4. Criar o schema

```bash
mysql -h 127.0.0.1 -u root -p < sql/schema.sql
```

## 5. Rodar o ETL (extração, tratamento, carga, queries, gráficos)

```bash
python -m nbconvert --to notebook --execute --inplace notebooks/etl.ipynb
```

Use `python -m nbconvert` (não `jupyter nbconvert`) — o script `jupyter`/
`jupyter-nbconvert` nem sempre fica exposto no PATH da venv, mas o módulo
`nbconvert` sempre pode ser invocado assim pelo interpretador ativo.

Ou abra `notebooks/etl.ipynb` no Jupyter/VS Code e rode célula a célula. O
notebook é idempotente: cada execução limpa (`TRUNCATE`) e recarrega as 3
tabelas, então pode ser reexecutado várias vezes sobre o mesmo banco.

## 6. Conferir os resultados

As respostas das 4 perguntas aparecem nas últimas células do notebook, junto
com os gráficos (salvos também como PNG em `notebooks/`). Os SQLs isolados
estão em `sql/queries/`.

## 7. Gerar o dump (entregável)

```bash
mysqldump -h 127.0.0.1 -u root -p --databases wellbe_desafio > sql/dump.sql
```

## Validação

Este documento foi validado executando os passos acima do zero, literalmente,
nesta sequência:

1. `DROP DATABASE IF EXISTS wellbe_desafio;`
2. `mysql ... < sql/schema.sql` → recriou as 3 tabelas vazias.
3. `python -m nbconvert --to notebook --execute --inplace notebooks/etl.ipynb`
   → rodou com a venv recém-criada (passo 2 deste doc) e ativada, exit code 0.
4. Conferência das contagens no banco: `20` departamentos, `28` funcionários,
   `90` atestados (mesmos números da carga original).
5. `mysqldump ... --databases wellbe_desafio > sql/dump.sql` → gerou o dump
   final commitado neste repositório.

Isso confirma que os passos 1–7 acima, seguidos do zero em uma máquina com
Python 3.11+ e MySQL/MariaDB acessível, reproduzem o banco completo sem
intervenção manual além de criar `.env` e (se aplicável) digitar a senha do
MySQL.
