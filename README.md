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
3. Visite <http://localhost:3000/tests> no seu navegador.

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
