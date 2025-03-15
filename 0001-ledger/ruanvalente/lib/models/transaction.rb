require 'date'
require_relative '../database'
require_relative '../services/transaction_service'

class Transaction
  attr_reader :id, :value, :date, :description

  def initialize(id:, value:, date:, description: nil)
    @id = id
    @value = value
    @date = date
    @description = description
  end

  def self.create_table
    Database.connection.execute(File.read(File.expand_path('../database/schema.sql', __dir__)))
  end

  def self.add(value:, description: nil)
    TransactionService.add(value: value, description: description)
  end

  def self.all
    TransactionService.all
  end

  def self.balance
    TransactionService.balance
  end

  def self.filtered(type: nil, start_date: nil, end_date: nil)
    TransactionService.filtered(type: type, start_date: start_date, end_date: end_date)
  end
end
