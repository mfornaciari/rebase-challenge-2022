require 'test/unit'
require './services/query_service'

class TestQuery < Test::Unit::TestCase
  def teardown
    require 'pg'
    connection = PG.connect dbname: 'medical_records', host: 'test-db', user: 'user', password: 'password'
    connection.exec('DROP TABLE IF EXISTS exams')
    connection.close
  end

  def test_get_tests_success
    require './services/import_service'
    import_service = ImportService.new(File.read('./tests/support/test_data.csv'))
    import_service.create_table
    import_service.insert_data
    expected_result = JSON.parse(File.read('./tests/support/test_response.json'))

    result = QueryService.new.get_tests

    assert_equal expected_result, JSON.parse(result)
  end

  def test_get_tests_db_empty
    result = QueryService.new.get_tests

    assert_equal false, result
  end
end