unless ENV['APP_ENV'] == 'test'
  puts 'ERRO: antes de executar os testes, mude para o ambiente de testes.'
  return
end

require 'test/unit'
require './services/csv_service'
require './services/query_service'

class TestQuery < Test::Unit::TestCase
  def test_get_tests_success
    CsvService.new('./tests/support/test_data.csv').import
    expected_result = JSON.parse(File.read('./tests/support/test_response.json'))

    result = QueryService.new.get_tests

    assert_equal expected_result, JSON.parse(result)

    require './tests/test_helper'
  end

  def test_get_tests_db_empty
    result = QueryService.new.get_tests

    assert_equal false, result

    require './tests/test_helper'
  end
end