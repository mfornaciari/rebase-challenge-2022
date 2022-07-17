require 'test/unit'
require_relative '../app/services/query_service'

class TestQuery < Test::Unit::TestCase
  def teardown
    require 'pg'
    connection = PG.connect dbname: 'medical_records', host: 'test-db', user: 'user', password: 'password'
    connection.exec('DROP TABLE IF EXISTS exams')
    connection.close
  end

  def test_get_tests_success
    require_relative '../app/services/import_service'
    import_service = ImportService.new
    import_service.create_table
    import_service.insert File.read("#{Dir.pwd}/support/test_data.csv")
    expected_result = JSON.parse(File.read("#{Dir.pwd}/support/test_db_data.json"))

    result = QueryService.new.get_tests

    assert_equal expected_result, JSON.parse(result)
  end

  def test_get_tests_db_empty
    result = QueryService.new.get_tests

    assert_equal false, result
  end
end