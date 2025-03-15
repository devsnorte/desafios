require 'minitest/autorun'
require_relative '../database'
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

  def test_create_transaction
    transaction = Transaction.new(id: 1, value: 200.0, date: '2025-03-15', description: 'Teste')
    assert_equal 1, transaction.id
    assert_equal 200.0, transaction.value
    assert_equal '2025-03-15', transaction.date
    assert_equal 'Teste', transaction.description
  end
end
