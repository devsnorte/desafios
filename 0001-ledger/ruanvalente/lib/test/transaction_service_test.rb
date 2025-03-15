require 'minitest/autorun'
require 'fileutils'
require 'json'
require 'csv'
require_relative '../database'
require_relative '../services/transaction_service'
require_relative '../models/transaction'

ENV['TEST'] = 'true'

class TransactionServiceTest < Minitest::Test
  def setup
    Database.setup
    Database.connection.execute('DELETE FROM transactions')
  end

  def teardown
    Database.connection.execute('DELETE FROM transactions')
  end

  def test_add_transaction
    assert_equal 0, TransactionService.all.count
    TransactionService.add(value: 100, description: 'Salário')
    assert_equal 1, TransactionService.all.count
  end

  def test_balance_calculation
    TransactionService.add(value: 500, description: 'Salário')
    TransactionService.add(value: -200, description: 'Aluguel')
    assert_equal 300.0, TransactionService.balance
  end

  def test_filter_by_type
    TransactionService.add(value: 100, description: 'Entrada')
    TransactionService.add(value: -50, description: 'Saída')

    entradas = TransactionService.filtered(type: 'entrada')
    saidas = TransactionService.filtered(type: 'saida')

    assert_equal 1, entradas.count
    assert_equal 1, saidas.count
    assert entradas.first.value.positive?
    assert saidas.first.value.negative?
  end
end
