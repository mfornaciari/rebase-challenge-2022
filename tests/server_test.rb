require 'test/unit'
require 'net/http'
require './services/import_service'

class TestServer < Test::Unit::TestCase
  def teardown
    require 'pg'
    connection = PG.connect dbname: 'medical_records', host: 'test-db', user: 'user', password: 'password'
    connection.exec('DROP TABLE IF EXISTS exams')
    connection.close
  end

  def test_get_tests_success
    import_service = ImportService.new
    import_service.create_table
    import_service.insert File.read('./tests/support/test_data.csv')
    expected_response_body = JSON.parse(File.read('./tests/support/test_db_data.json'))

    response = Net::HTTP.get_response 'localhost', '/tests', 3000

    assert_equal '200', response.code
    assert_equal 'application/json', response['Content-Type']
    assert_equal expected_response_body, JSON.parse(response.body)
  end

  def test_get_tests_db_empty
    response = Net::HTTP.get_response 'localhost', '/tests', 3000

    assert_equal '200', response.code
    assert_equal 'text/plain;charset=utf-8', response['Content-Type']
    assert_equal 'Não há exames registrados.'.force_encoding('ascii-8bit'), response.body
  end

  def test_post_import_success
    require './services/query_service'
    http = Net::HTTP.new('localhost', 3000)
    request = Net::HTTP::Post.new('/import', 'Content-Type': 'text/csv')
    request.body = File.read('./tests/support/test_data.csv')
    expected_db_data = JSON.parse(File.read('./tests/support/test_db_data.json'))

    response = http.request(request)

    assert_equal '201', response.code
    assert_equal 'Dados importados com sucesso.'.force_encoding('ascii-8bit'), response.body
    assert_equal expected_db_data, JSON.parse(QueryService.new.get_tests)
  end

  def test_post_import_invalid_data
    http = Net::HTTP.new('localhost', 3000)
    request = Net::HTTP::Post.new('/import', 'Content-Type': 'text/csv')
    request.body = File.read('./tests/support/test_invalid_data.csv')

    response = http.request(request)

    assert_equal '422', response.code
    assert_equal 'Formato dos dados incorreto.'.force_encoding('ascii-8bit'), response.body
  end
end
