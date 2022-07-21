# Rebase Challenge 2022

API em Ruby para listagem de exames médicos.

A construção desta aplicação é objeto do [**Desafio Rebase 2022**](https://git.campuscode.com.br/core-team/rebase-challenge-2022).

Acompanhe o desenvolvimento na [**página do _GitHub Projects_**](https://github.com/users/mfornaciari/projects/3).

## Tech Stack

* [Docker](https://www.docker.com/)
* [Ruby](https://www.ruby-lang.org/en/)

## Executando o projeto

1. Garanta que o Docker está instalado e operacional.
2. Execute os contêineres Docker:

    ```text
    docker compose up
    ```

3. Espere alguns segundos para o servidor entrar no ar.
4. Acesse o [_endpoint_](#endpoints) desejado.

### Executando testes

Após colocar o servidor no ar, execute o seguinte comando em outro terminal:

```text
docker exec rebase-challenge-2022-tests-1 bash -c "cd ../tests && ruby run_tests.rb"
```

## Endpoints

### GET /tests

Acessando o endereço <localhost:3000/tests>, é possível visualizar todos os exames cadastrados no banco de dados. O servidor retorna uma resposta com status HTTP 200 ("OK") como a seguinte:

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

Caso não haja exames cadastrados no banco de dados, o servidor retorna uma resposta com status HTTP 200 ("OK") como a seguinte:

Headers:

```text
Content-Type: text/plain;charset=utf-8
X-Content-Type-Options: nosniff
Content-Length: 28
```

Body:

```text
Não há exames registrados.
```

### GET /tests/:token

Acessando o endereço <localhost:3000/tests/:token>, onde `:token` é o _token_ identificador de um exame, é possível visualizar todos os dados relativos ao exame em questão cadastrados no banco de dados. Por exemplo: acessando <localhost:3000/tests/AIWH8Y>, procuraríamos os dados relativos ao exame identificado pelo _token_ AIWH8Y. Se um exame com esse _token_ estiver cadastrado no banco de dados, o servidor retorna uma resposta com status HTTP 200 ("OK") como a seguinte:

Headers:

```text
Content-Type: application/json
X-Content-Type-Options: nosniff
Content-Length: 1377
```

Body:

```text
{
    "cpf": "071.488.453-78",
    "nome paciente": "Antônio Rebouças",
    "email paciente": "adalberto_grady@feil.org",
    "data nascimento paciente": "1999-04-11",
    "token resultado exame": "AIWH8Y",
    "data exame": "2021-06-29",
    "médico": {
        "crm médico": "B0002W2RBG",
        "crm médico estado": "SP",
        "nome médico": "Dra. Isabelly Rêgo"
    },
    "exames": [
        {
            "tipo exame": "hemácias",
            "limites tipo exame": "45-52",
            "resultado tipo exame": "6"
        },
        {
            "tipo exame": "vldl",
            "limites tipo exame": "48-72",
            "resultado tipo exame": "88"
        },
          ...
    ]
}
```

Se não houver exames cadastrados com o _token_ informado no banco de dados, o servidor retorna uma resposta com status HTTP 404 ("Not Found") como a seguinte:

Headers:

```text
Content-Type: text/plain;charset=utf-8
X-Content-Type-Options: nosniff
Content-Length: 43
```

Body:

```text
Não há exames registrados com esse token.
```

### POST /import

Enviando uma requisição POST para <localhost:3000/import>, é possível adicionar novos dados ao banco de forma **assíncrona**. A requisição deve conter dados CSV no seu corpo e ser estruturada como a seguinte:

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

Caso receba uma requisição com dados CSV que não contêm o número adequado de colunas (16), o servidor retorna uma resposta com status HTTP 422 ("Unprocessable Entity") como a seguinte:

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

Executando o script `import_from_csv.rb`, é possível substituir, de forma **assíncrona**, todos os dados atualmente no banco por aqueles definidos no arquivo `data.csv`:

```text
docker exec rebase-challenge-2022-app-1 ruby import_from_csv.rb
```
