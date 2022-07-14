unless ENV['APP_ENV'] == 'test'
  puts 'ERRO: antes de executar os testes, mude para o ambiente de testes.'
  return
end

require 'test/unit'
require 'net/http'
require './services/csv_service'

class TestServer < Test::Unit::TestCase
  def test_server
    CsvService.new('./tests/support/test_data.csv').import
    expected_response = JSON.parse(File.read('./tests/support/test_response.json'))

    response = Net::HTTP.get_response 'localhost', '/tests', 3000

    assert_equal response.code, '200'
    assert_equal response['Content-Type'], 'application/json'
    assert_equal JSON.parse(response.body), expected_response
  end
end
