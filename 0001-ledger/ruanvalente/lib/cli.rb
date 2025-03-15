require 'terminal-table'
require_relative 'models/transaction'

Transaction.create_table

class CLI
  def self.run
    loop do
      show_menu
      choice = gets.chomp.to_i
      handle_choice(choice)
    end
  end

  def self.show_menu
    puts "\nLedger - Escolha uma opção:"
    puts '1. Adicionar transação'
    puts '2. Listar transações'
    puts '3. Consultar saldo'
    puts '4. Exportar histórico'
    puts '5. Sair'
    print '> '
  end

  def self.handle_choice(choice)
    case choice
    when 1 then add_transaction
    when 2 then list_transactions
    when 3 then show_balance
    when 4 then export_transactions
    when 5 then exit_program
    else puts 'Opção inválida!'
    end
  end

  def self.add_transaction
    print 'Valor (positivo para entrada, negativo para saída): '
    value = gets.chomp.to_f
    print 'Descrição: '
    description = gets.chomp
    Transaction.add(value: value, description: description)
    puts 'Transação adicionada!'
  end

  def self.list_transactions
    print 'Filtrar por tipo? (entrada/saída/deixar em branco para todas): '
    type = gets.chomp.downcase
    type = nil if type.empty?

    print 'Filtrar por data inicial? (YYYY-MM-DD ou deixar em branco): '
    start_date = gets.chomp
    start_date = nil if start_date.empty?

    print 'Filtrar por data final? (YYYY-MM-DD ou deixar em branco): '
    end_date = gets.chomp
    end_date = nil if end_date.empty?

    transactions = Transaction.filtered(type: type, start_date: start_date, end_date: end_date)

    return puts 'Nenhuma transação encontrada com esses filtros.' if transactions.empty?

    rows = transactions.map { |t| [t.id, t.date, t.value, t.description || '-'] }

    table = Terminal::Table.new(
      title: 'Histórico de Transações',
      headings: %W[ID Data Valor Descri\u00E7\u00E3o],
      rows: rows
    )

    puts table
  end

  def self.show_balance
    puts "Saldo atual: #{Transaction.balance}"
  end

  def self.exit_program
    puts 'Saindo...'
    exit
  end

  def self.export_transactions
    print 'Escolha o formato para exportação (csv/json): '
    format = gets.chomp.downcase

    case format
    when 'csv'
      filename = 'export/transactions.csv'
      TransactionService.export_to_csv(filename)
      puts "Transações exportadas para #{filename}!"
    when 'json'
      filename = 'export/transactions.json'
      TransactionService.export_to_json(filename)
      puts "Transações exportadas para #{filename}!"
    else
      puts "Formato inválido. Escolha 'csv' ou 'json'."
    end
  end
end

CLI.run
