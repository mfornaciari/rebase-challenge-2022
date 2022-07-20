require 'test/unit'
require 'sidekiq/testing'
require 'net/http'
require_relative '../app/services/import_service'

class TestServer < Test::Unit::TestCase
  def teardown
    require 'pg'
    connection = PG.connect dbname: 'medical_records', host: 'test-db', user: 'user', password: 'password'
    connection.exec('DROP TABLE IF EXISTS exams')
    connection.close
  end

  def test_get_tests_success
    import_service = ImportService.new('test-db')
    import_service.create_table
    CSV.foreach("#{Dir.pwd}/support/test_query_data.csv", headers: true, col_sep: ';') do |row|
      import_service.insert row.fields
    end
    expected_response_body = JSON.parse(File.read("#{Dir.pwd}/support/test_query_db_data.json"))

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
    require_relative '../app/services/query_service'
    http = Net::HTTP.new('localhost', 3000)
    request = Net::HTTP::Post.new('/import', 'Content-Type': 'text/csv')
    request.body = File.read("#{Dir.pwd}/support/test_query_data.csv")
    expected_db_data = JSON.parse(File.read("#{Dir.pwd}/support/test_query_db_data.json"))

    response = http.request(request)

    assert_equal '201', response.code
    assert_equal 'Dados importados com sucesso.'.force_encoding('ascii-8bit'), response.body
    assert_equal expected_db_data, JSON.parse(QueryService.new.get_tests)
  end

  def test_post_import_multiple_times
    require_relative '../app/services/query_service'
    http = Net::HTTP.new('localhost', 3000)
    request1 = Net::HTTP::Post.new('/import', 'Content-Type': 'text/csv')
    request1.body = File.read("#{Dir.pwd}/support/test_data1.csv")
    request2 = Net::HTTP::Post.new('/import', 'Content-Type': 'text/csv')
    request2.body = File.read("#{Dir.pwd}/support/test_data2.csv")
    expected_db_data = JSON.parse(File.read("#{Dir.pwd}/support/test_multiple_insert_db_data.json"))

    http.request(request1)
    http.request(request2)

    assert_equal expected_db_data, JSON.parse(QueryService.new.get_tests)
  end

  def test_post_import_invalid_data
    http = Net::HTTP.new('localhost', 3000)
    request = Net::HTTP::Post.new('/import', 'Content-Type': 'text/csv')
    request.body = File.read("#{Dir.pwd}/support/test_invalid_data.csv")

    response = http.request(request)

    assert_equal '422', response.code
    assert_equal 'Formato dos dados incorreto.'.force_encoding('ascii-8bit'), response.body
  end
end
