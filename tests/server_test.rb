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

    assert_equal '200', response.code
    assert_equal 'application/json', response['Content-Type']
    assert_equal expected_response, JSON.parse(response.body)
  end
end
