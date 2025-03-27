Mix.install([
  {:plug_cowboy, "~> 2.5"},
  {:jason, "~> 1.2"},
  {:uuid, "~> 1.1"}
])

defmodule LedgerRepo do
  @moduledoc """
  Repositório para gerenciar transações do ledger usando GenServer.
  Mantém o estado das transações e fornece operações básicas de CRUD.
  """
  use GenServer

  # API pública
  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def insert(transaction) do
    GenServer.call(__MODULE__, {:insert, transaction})
  end

  def get_transactions do
    GenServer.call(__MODULE__, :get_transactions)
  end

  def get_balance do
    GenServer.call(__MODULE__, :get_balance)
  end

  def get_transactions_by_type(type) do
    GenServer.call(__MODULE__, {:get_by_type, type})
  end

  def get_transactions_by_date(start_date, end_date) do
    GenServer.call(__MODULE__, {:get_by_date, start_date, end_date})
  end

  # Callbacks do GenServer
  @impl true
  def init(_) do
    {:ok, []}
  end

  @impl true
  def handle_call({:insert, transaction}, _from, transactions) do
    {:reply, {:ok, transaction}, [transaction | transactions]}
  end

  @impl true
  def handle_call(:get_transactions, _from, transactions) do
    sorted = Enum.sort_by(transactions, & &1.date, :desc)
    {:reply, sorted, transactions}
  end

  @impl true
  def handle_call(:get_balance, _from, transactions) do
    balance = Enum.reduce(transactions, 0, fn t, acc -> acc + t.value end)
    {:reply, balance, transactions}
  end

  @impl true
  def handle_call({:get_by_type, :income}, _from, transactions) do
    filtered = Enum.filter(transactions, fn t -> t.value > 0 end)
    sorted = Enum.sort_by(filtered, & &1.date, :desc)
    {:reply, sorted, transactions}
  end

  @impl true
  def handle_call({:get_by_type, :expense}, _from, transactions) do
    filtered = Enum.filter(transactions, fn t -> t.value < 0 end)
    sorted = Enum.sort_by(filtered, & &1.date, :desc)
    {:reply, sorted, transactions}
  end

  @impl true
  def handle_call({:get_by_date, start_date, end_date}, _from, transactions) do
    filtered =
      if start_date && end_date do
        Enum.filter(transactions, fn t ->
          t.date >= start_date && t.date <= end_date
        end)
      else
        transactions
      end

    sorted = Enum.sort_by(filtered, & &1.date, :desc)
    {:reply, sorted, transactions}
  end
end

defmodule LedgerRouter do
  @moduledoc """
  Router HTTP para a API do Ledger.
  Fornece endpoints para gerenciar transações financeiras.
  """
  use Plug.Router
  require Logger

  plug Plug.Logger
  plug :match
  plug Plug.Parsers, parsers: [:json], json_decoder: Jason
  plug :dispatch

  post "/transactions" do
    {status, body} =
      case conn.body_params do
        %{"value" => value, "description" => description} when is_number(value) ->
          transaction = %{
            id: UUID.uuid4(),
            value: value,
            description: description,
            date: DateTime.utc_now() |> DateTime.to_iso8601()
          }

          LedgerRepo.insert(transaction)
          {201, transaction}

        _ ->
          {400, %{error: "Valores inválidos. Forneça 'value' (número) e 'description' (string)."}}
      end

    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(body))
  end

  get "/balance" do
    balance = LedgerRepo.get_balance()

    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{balance: balance}))
  end

  get "/transactions" do
    transactions = LedgerRepo.get_transactions()

    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{transactions: transactions}))
  end

  get "/transactions/type/:type" do
    transactions =
      case type do
        "income" -> LedgerRepo.get_transactions_by_type(:income)
        "expense" -> LedgerRepo.get_transactions_by_type(:expense)
        _ -> []
      end

    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{transactions: transactions}))
  end

  get "/transactions/date" do
    {start_date, end_date} =
      case conn.query_params do
        %{"start" => start, "end" => end_date} -> {start, end_date}
        _ -> {nil, nil}
      end

    transactions = LedgerRepo.get_transactions_by_date(start_date, end_date)

    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{transactions: transactions}))
  end

  get "/export/json" do
    transactions = LedgerRepo.get_transactions()

    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> Plug.Conn.put_resp_header(
      "content-disposition",
      "attachment; filename=\"ledger_export.json\""
    )
    |> send_resp(200, Jason.encode!(%{transactions: transactions}))
  end

  get "/export/csv" do
    transactions = LedgerRepo.get_transactions()

    csv_content =
      ["id,value,description,date\n"] ++
        Enum.map(transactions, fn t ->
          "#{t.id},#{t.value},#{t.description},#{t.date}\n"
        end)

    conn
    |> Plug.Conn.put_resp_content_type("text/csv")
    |> Plug.Conn.put_resp_header(
      "content-disposition",
      "attachment; filename=\"ledger_export.csv\""
    )
    |> send_resp(200, csv_content)
  end

  match _ do
    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> send_resp(404, Jason.encode!(%{error: "Não encontrado"}))
  end
end

{:ok, _} = LedgerRepo.start_link()

{:ok, _} = Plug.Cowboy.http(LedgerRouter, [], port: 4000)

IO.puts("Servidor iniciado em http://localhost:4000")

:timer.sleep(:infinity)
