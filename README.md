# Rebase Challenge 2022

API em Ruby para listagem de exames médicos.

## Tech Stack

* Docker
* Ruby

## Executando o projeto

1. Execute o seguinte comando no terminal:

    ```text
    docker compose up
    ```

2. Espere alguns segundos para o servidor entrar no ar.

### Executando testes

1. Execute o seguinte comando no terminal:

    ```text
    docker compose -f docker-compose.yml -f docker-compose.test.yml up -d
    ```

2. Espere alguns segundos para o servidor entrar no ar.
3. Execute o seguinte comando no terminal:

    ```text
    docker exec -it rebase-challenge-2022-app-1 ruby run_tests.rb
    ```

## Endpoints

### GET /tests

Acessando o endereço <localhost:3000/tests>, é possível visualizar todos os exames cadastrados no banco de dados. O servidor envia uma resposta com status HTTP 200 ("OK") como a seguinte:

Headers:

```text
Content-Type: application/json
X-Content-Type-Options: nosniff
Content-Length: 2070027
```

Body:

```text
[
  {
    "cpf": "048.973.170-88",
    "nome_paciente": "Emilly Batista Neto",
    "email_paciente": "gerald.crona@ebert-quigley.com",
    "data_nascimento_paciente": "2001-03-11",
    "endereco_paciente": "165 Rua Rafaela",
    "cidade_paciente": "Ituverava",
    "estado_patiente": "Alagoas",
    "crm_medico": "B000BJ20J4",
    "crm_medico_estado": "PI",
    "nome_medico": "Maria Luiza Pires",
    "email_medico": "denna@wisozk.biz",
    "token_resultado_exame": "IQCZ17",
    "data_exame": "2021-08-05",
    "tipo_exame": "leucócitos",
    "limites_tipo_exame": "9-61",
    "resultado_tipo_exame": "89"
  },
    ...
]
```

### POST /import

Enviando uma requisição POST para localhost:3000/import, é possível adicionar novos dados ao banco. A requisição deve ser estruturada como a seguinte:

Headers:

```text
Content_Type: text/csv
```

Body:

```text
cpf;nome paciente;email paciente;data nascimento paciente;endereço/rua paciente;cidade paciente;estado patiente;crm médico;crm médico estado;nome médico;email médico;token resultado exame;data exame;tipo exame;limites tipo exame;resultado tipo exame
048.973.170-88;Emilly Batista Neto;gerald.crona@ebert-quigley.com;2001-03-11;165 Rua Rafaela;Ituverava;Alagoas;B000BJ20J4;PI;Maria Luiza Pires;denna@wisozk.biz;IQCZ17;2021-08-05;hemácias;45-52;97
```

Caso receba uma requisição adequada, o servidor retorna uma resposta com status HTTP 201 ("Created") como a seguinte:

Headers:

```text
Content-Type: text/html;charset=utf-8
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
X-Frame-Options: SAMEORIGIN
Content-Length: 29
```

Body:

```text
Dados importados com sucesso.
```

Caso receba uma requisição em formato incorreto, o servidor retorna uma resposta com status HTTP 422 ("Unprocessable Entity") como a seguinte:

Headers:

```text
Content-Type: text/html;charset=utf-8
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
X-Frame-Options: SAMEORIGIN
Content-Length: 28
```

Body:

```text
Formato dos dados incorreto.
```

## Importando dados manualmente

Executando o script `import_from_csv.rb`, é possível substituir todos os dados atualmente no banco por aqueles definidos no arquivo `data.csv`.
