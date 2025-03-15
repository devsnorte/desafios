require 'csv'
require 'json'
require 'fileutils'

require_relative '../database'

class TransactionService
  def self.add(value:, description: nil)
    date = Date.today.to_s
    Database.connection.execute('INSERT INTO transactions (value, date, description) VALUES (?, ?, ?)',
                                [value, date, description])
  end

  def self.all
    Database.connection.execute('SELECT * FROM transactions ORDER BY date DESC, id DESC').map do |row|
      Transaction.new(id: row[0], value: row[1], date: row[2], description: row[3])
    end
  end

  def self.balance
    Database.connection.get_first_value('SELECT SUM(value) FROM transactions').to_f
  end

  def self.filtered(type: nil, start_date: nil, end_date: nil)
    query = 'SELECT * FROM transactions'
    conditions = []
    params = []

    if type
      conditions << (type == 'entrada' ? 'value > 0' : 'value < 0')
    end

    if start_date
      conditions << 'date >= ?'
      params << start_date
    end

    if end_date
      conditions << 'date <= ?'
      params << end_date
    end

    query += " WHERE #{conditions.join(' AND ')}" unless conditions.empty?
    query += ' ORDER BY date DESC, id DESC'

    Database.connection.execute(query, params).map do |row|
      Transaction.new(id: row[0], value: row[1], date: row[2], description: row[3])
    end
  end

  def self.export_to_csv(filename)
    transactions = all

    FileUtils.mkdir_p('export')
    CSV.open(filename, 'w', headers: true) do |csv|
      csv << %W[ID Data Valor Descri\u00E7\u00E3o]
      transactions.each { |t| csv << [t.id, t.date, t.value, t.description || '-'] }
    end
  end

  def self.export_to_json(filename)
    transactions = all.map do |t|
      { id: t.id, date: t.date, value: t.value, description: t.description }
    end

    FileUtils.mkdir_p('export')
    File.write(filename, JSON.pretty_generate(transactions))
  end
end
