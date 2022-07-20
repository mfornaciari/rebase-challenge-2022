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
    import_service = ImportService.new('test-db')
    import_service.create_table
    CSV.foreach("#{Dir.pwd}/support/test_query_data.csv", headers: true, col_sep: ';') do |row|
      import_service.insert row.fields
    end
    expected_result = JSON.parse(File.read("#{Dir.pwd}/support/test_query_db_data.json"))

    result = QueryService.new.get_tests

    assert_equal expected_result, JSON.parse(result)
  end

  def test_get_tests_db_empty
    result = QueryService.new.get_tests

    assert_equal false, result
  end
end