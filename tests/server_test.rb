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
    import_service = ImportService.new(File.read('./tests/support/test_data.csv'))
    import_service.create_table
    import_service.insert_data
    expected_response = JSON.parse(File.read('./tests/support/test_response.json'))

    response = Net::HTTP.get_response 'localhost', '/tests', 3000

    assert_equal '200', response.code
    assert_equal 'application/json', response['Content-Type']
    assert_equal expected_response, JSON.parse(response.body)
  end

  def test_get_tests_db_empty
    response = Net::HTTP.get_response 'localhost', '/tests', 3000

    assert_equal '200', response.code
    assert_equal 'text/plain;charset=utf-8', response['Content-Type']
    assert_equal 'Não há exames registrados'.force_encoding('ascii-8bit'), response.body
  end

  def test_post_import_success
    require './services/query_service'
    http = Net::HTTP.new('localhost', 3000)
    request = Net::HTTP::Post.new('/import', 'Content-Type': 'text/csv')
    request.body = File.read('./tests/support/test_data.csv')
    expected_data = JSON.parse(File.read('./tests/support/test_response.json'))

    response = http.request(request)

    assert_equal '201', response.code
    assert_equal expected_data, JSON.parse(QueryService.new.get_tests)
  end
end
