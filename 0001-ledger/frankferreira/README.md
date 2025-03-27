# Ledger API

Uma API simples em Elixir para registrar transações financeiras, consultar saldo e exportar histórico.

## Instalação e Execução

1. Certifique-se de ter [Elixir instalado](https://elixir-lang.org/install.html) (versão 1.12+)
2. Execute o arquivo:

```bash
elixir ledger.exs
```

A API estará disponível em `http://localhost:4000`.

## Endpoints e Exemplos de Uso

Abaixo estão todos os endpoints disponíveis com exemplos de uso utilizando `curl`.

### 1. Cadastrar uma Transação (Entrada/Receita)

**Endpoint:**
```
POST /transactions
```

**Parâmetros:**
- `value` (number): Valor da transação (positivo para entrada, negativo para saída)
- `description` (string): Descrição da transação

**Exemplo de requisição (entrada):**
```bash
curl -X POST http://localhost:4000/transactions \
  -H "Content-Type: application/json" \
  -d '{"value": 10000.00, "description": "Salário 🤑"}'
```

**Resposta esperada:**
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "value": 10000.00,
  "description": "Salário 🤑",
  "date": "2025-03-27T14:30:27Z"
}
```

### 2. Cadastrar uma Transação (Saída/Despesa)

**Exemplo de requisição (saída):**
```bash
curl -X POST http://localhost:4000/transactions \
  -H "Content-Type: application/json" \
  -d '{"value": -5000.00, "description": "Supermercado 🛒"}'
```

**Resposta esperada:**
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440001",
  "value": -5000.00,
  "description": "Supermercado 🛒",
  "date": "2025-03-27T14:31:05Z"
}
```

### 3. Consultar Saldo Atual

**Endpoint:**
```
GET /balance
```

**Exemplo de requisição:**
```bash
curl http://localhost:4000/balance
```

**Resposta esperada:**
```json
{
  "balance": 849.75
}
```

### 4. Listar Histórico de Transações

**Endpoint:**
```
GET /transactions
```

**Exemplo de requisição:**
```bash
curl http://localhost:4000/transactions
```

**Resposta esperada:**
```json
{
  "transactions": [
    {
      "id": "550e8400-e29b-41d4-a716-446655440001",
      "value": -5000.00,
      "description": "Supermercado 🛒",
      "date": "2025-03-27T14:31:05Z"
    },
    {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "value": 10000.00,
      "description": "Salário 🤑",
      "date": "2025-03-27T14:30:27Z"
    }
  ]
}
```

### 5. Filtrar Transações por Tipo (Entradas)

**Endpoint:**
```
GET /transactions/type/:type
```

**Exemplo de requisição (entradas):**
```bash
curl http://localhost:4000/transactions/type/income
```

**Resposta esperada:**
```json
{
  "transactions": [
    {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "value": 10000.00,
      "description": "Salário 🤑",
      "date": "2025-03-27T14:30:27Z"
    }
  ]
}
```

### 6. Filtrar Transações por Tipo (Saídas)

**Exemplo de requisição (saídas):**
```bash
curl http://localhost:4000/transactions/type/expense
```

**Resposta esperada:**
```json
{
  "transactions": [
    {
      "id": "550e8400-e29b-41d4-a716-446655440001",
      "value": -5000.00,
      "description": "Supermercado 🛒",
      "date": "2025-03-27T14:31:05Z"
    }
  ]
}
```

### 7. Filtrar Transações por Data

**Endpoint:**
```
GET /transactions/date?start=DATA_INICIO&end=DATA_FIM
```

**Parâmetros:**
- `start` (string): Data de início no formato ISO8601 (ex: "2025-03-01T00:00:00Z")
- `end` (string): Data de fim no formato ISO8601 (ex: "2025-03-31T23:59:59Z")

**Exemplo de requisição:**
```bash
curl "http://localhost:4000/transactions/date?start=2025-03-01T00:00:00Z&end=2025-03-31T23:59:59Z"
```

**Resposta esperada:**
```json
{
  "transactions": [
    {
      "id": "550e8400-e29b-41d4-a716-446655440001",
      "value": -5000.00,
      "description": "Supermercado 🛒",
      "date": "2025-03-27T14:31:05Z"
    },
    {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "value": 10000.00,
      "description": "Salário 🤑",
      "date": "2025-03-27T14:30:27Z"
    }
  ]
}
```

### 8. Exportar Transações como JSON

**Endpoint:**
```
GET /export/json
```

**Exemplo de requisição:**
```bash
curl -o ledger_export.json http://localhost:4000/export/json
```

**Resposta esperada:**
Arquivo `ledger_export.json` com o conteúdo:
```json
{
  "transactions": [
    {
      "id": "550e8400-e29b-41d4-a716-446655440001",
      "value": -5000.00,
      "description": "Supermercado 🛒",
      "date": "2025-03-27T14:31:05Z"
    },
    {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "value": 10000.00,
      "description": "Salário 🤑",
      "date": "2025-03-27T14:30:27Z"
    }
  ]
}
```

### 9. Exportar Transações como CSV

**Endpoint:**
```
GET /export/csv
```

**Exemplo de requisição:**
```bash
curl -o ledger_export.csv http://localhost:4000/export/csv
```

**Resposta esperada:**
Arquivo `ledger_export.csv` com o conteúdo:
```
id,value,description,date
550e8400-e29b-41d4-a716-446655440001,-5000.00,Supermercado 🛒,2025-03-27T14:31:05Z
550e8400-e29b-41d4-a716-446655440000,10000.00,Salário 🤑,2025-03-27T14:30:27Z
```

## Especificações Técnicas

### Estrutura do Código

A API é construída como um único arquivo `.exs` contendo:

- **LedgerRepo**: Módulo responsável pelo armazenamento e gerenciamento dos dados usando GenServer
- **LedgerRouter**: Módulo responsável pela definição das rotas e processamento das requisições HTTP

### Persistência de Dados

Os dados são armazenados em memória usando um GenServer. Isso significa que os dados serão perdidos se o servidor for reiniciado.

### Modelo de Dados

Cada transação é representada por um mapa com a seguinte estrutura:

```
%{
  id: "550e8400-e29b-41d4-a716-446655440000",
  value: 10000.00,
  description: "Salário 🤑",
  date: "2025-03-27T14:30:27Z"
}
```

## Escolha da Stack

Elixir foi escolhido para este projeto pelas seguintes razões:

- **Simplicidade**: Permite implementação mínima em um único arquivo
- **Concorrência eficiente**: Baseado na VM Erlang (BEAM), oferece excelente performance
- **Funcionamento stateless**: Facilita a implementação de APIs
- **Tolerância a falhas**: Implementação de GenServer com supervisão natural do OTP
