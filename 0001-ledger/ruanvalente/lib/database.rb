require 'sqlite3'

class Database
  def self.connection
    @db ||= SQLite3::Database.new(database_path)
  end

  def self.database_path
    ENV['TEST'] == 'true' ? 'ledger_test.db' : 'ledger.db'
  end

  def self.setup
    connection.execute <<-SQL
      CREATE TABLE IF NOT EXISTS transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        value REAL NOT NULL,
        date TEXT NOT NULL,
        description TEXT
      )
    SQL
  end
end
