# 📒 Ledger API

Uma API REST simples para controle de transações financeiras (entradas e saídas), escrita em **Spring Boot**.

## 🚀 Funcionalidades

- ✅ Cadastrar transações (`ENTRADA` ou `SAÍDA`)
- ✅ Listar histórico completo de transações
- ✅ Filtrar histórico por:
  - Tipo da transação (`ENTRADA` ou `SAÍDA`)
  - Intervalo de datas (`startDate`, `endDate`)
- ✅ Calcular saldo atual
- ✅ Exportar transações em formato **CSV** ou **JSON**

---

## 📦 Instalação

### Pré-requisitos

- Java 17+
- Maven 3.8+

### Rodando localmente

```bash
./mvnw spring-boot:run
````

## 🔗 Endpoints

Base URL: `http://localhost:8080/api`

| Método | Rota                   | Descrição                         |
| ------ | ---------------------- | --------------------------------- |
| POST   | `/transactions`        | Cria uma nova transação           |
| GET    | `/transactions`        | Lista as transações (com filtros) |
| GET    | `/balance`             | Retorna o saldo atual             |
| GET    | `/transactions/export` | Exporta transações CSV ou JSON    |

### 🔍 Filtros (opcionais):

* `type`: `ENTRADA` ou `SAÍDA`
* `startDate`: formato ISO (ex: `2025-06-22T00:00:00`)
* `endDate`: formato ISO (ex: `2025-06-22T23:59:59`)
* `format`: `csv` (padrão) ou `json` (para exportação)

---

## 📘 Exemplo de Requisição

### POST `/api/transactions`

```json
{
  "amount": 250.00,
  "description": "Freelance",
  "type": "ENTRADA"
}
```

### GET `/api/transactions/export?type=SAÍDA&format=csv`

Baixa um arquivo `.csv` com todas as transações do tipo saída.

---

## 🛠️ Tecnologias

* Java 17
* Spring Boot
* Spring Web
* Spring Data JPA
* H2 Database
* Lombok
* Swagger (OpenAPI)
* Jackson

---

## 🔍 Documentação Swagger

Acesse a documentação interativa via Swagger:

```
http://localhost:8080/swagger-ui.html
```

---

## 🧑‍💻 Autor

Feito com ❤️ por [Edson Costa](https://github.com/ecsistem)

---

