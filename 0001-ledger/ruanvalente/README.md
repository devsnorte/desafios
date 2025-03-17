# Ledger CLI

Ledger CLI é uma aplicação simples de gestão financeira via linha de comando (CLI) utilizando **Ruby** e **SQLite**. O projeto faz parte de um desafio fornecido pela comunidade [DevsNorte](https://github.com/devsnorte/desafios/tree/main/0001-ledger).

## ✨ Funcionalidades

- **Adicionar transações** (entradas e saídas)
- **Listar transações** em ordem cronológica
- **Filtrar transações** por tipo ou intervalo de datas
- **Consultar saldo atual**
- **Exportar histórico** em CSV ou JSON

## 📝 Requisitos

- **Ruby** (versão 3.0 ou superior)
- **SQLite3**

📌 Escolha da Stack

A escolha de Ruby para este projeto foi motivada pelo fato de ter sido a primeira linguagem com a qual tive contato para aprendizado. Durante esse processo, percebi que Ruby é uma ferramenta poderosa, simples e eficaz, permitindo um desenvolvimento ágil e conciso. Sua sintaxe intuitiva e a vasta comunidade de suporte tornam o desenvolvimento mais produtivo e prazeroso.

Além disso, como a ideia do desafio era utilizar o que há de mais "simples" dentro da linguagem para a entrega, optei por soluções nativas e diretas. A utilização do SQLite3 também se justifica pela sua leveza e facilidade de integração em aplicações pequenas, sem necessidade de um servidor de banco de dados dedicado.

## ♻️ Instalação

1. Clone o repositório:

   ```sh
   git clone https://github.com/ruanvalente/ledger_api_cli
   cd ledger-api_cli
   ```

2. Instale as dependências:

   ```sh
   bundle install
   ```

3. Configure o banco de dados SQLite:
   ```sh
   ruby lib/models/transaction.rb
   ```

## ⚙️ Uso

Para iniciar a aplicação, execute:

```sh
ruby cli.rb
```

### ⚙️ Opções no menu

- **1** - Adicionar transação
- **2** - Listar transações
- **3** - Consultar saldo
- **4** - Exportar histórico
- **5** - Sair

### ⚖️ Filtrar Transações

Ao listar transações, é possível aplicar filtros:

- **Tipo**: Entrada (valor positivo) ou Saída (valor negativo)
- **Período**: Informar intervalo de datas no formato `AAAA-MM-DD`

## 📚 Exportação de Dados

É possível exportar as transações para **CSV** ou **JSON**:

```sh
Escolha o formato para exportação (csv/json):
```

Os arquivos serão salvos na pasta `export/`.

## 🏢 Estrutura do Projeto

```
ledger/
├── cli.rb                 # Interface de linha de comando
├── database/
│   ├── schema.sql         # Estrutura do banco de dados
├── lib/
│   ├── models/
│   │   ├── transaction.rb # Modelo de transação
│   ├── services/
│   │   ├── transaction_service.rb # Lógica de negócio
│   |── test/
│   │   ├── transaction_service_test # Testes unitários
├── export/                # Diretório de arquivos exportados
├── Gemfile                # Dependências do projeto
├── Rakefile               # Tarefas automatizadas
└── README.md              # Documentação
```

## 🛠️ Contribuição

Sinta-se à vontade para contribuir! Abra uma _issue_ ou envie um _pull request_ no repositório.

## 💪 Licença

Este projeto está licenciado sob a **MIT License**.
