require 'test/unit'
require './services/import_service'

class TestImport < Test::Unit::TestCase
  def teardown
    require 'pg'
    connection = PG.connect dbname: 'medical_records', host: 'test-db', user: 'user', password: 'password'
    connection.exec('DROP TABLE IF EXISTS exams')
    connection.close
  end

  def test_create_table_success
    connection = PG.connect dbname: 'medical_records', host: 'test-db', user: 'user', password: 'password'
    columns = CSV.read('./tests/support/test_data.csv', headers: true, col_sep: ';').headers

    ImportService.new.create_table
    db_columns = connection.exec(
      "SELECT column_name FROM information_schema.columns WHERE table_name = 'exams'"
    ).values.flatten
    connection.close

    db_columns.each { |column| assert_include columns, column }
  end

  def test_create_table_already_exists
    connection = PG.connect dbname: 'medical_records', host: 'test-db', user: 'user', password: 'password'
    columns = CSV.read('./tests/support/test_data.csv', headers: true, col_sep: ';').headers
    import_service = ImportService.new
    import_service.create_table

    import_service.create_table
    db_columns = connection.exec(
      "SELECT column_name FROM information_schema.columns WHERE table_name = 'exams'"
    ).values.flatten
    connection.close

    db_columns.each { |column| assert_include columns, column }
  end

  def test_insert_data_success
    require './services/query_service'
    expected_db_data = JSON.parse(File.read('./tests/support/test_db_data.json'))
    import_service = ImportService.new
    import_service.create_table

    import_service.insert File.read('./tests/support/test_data.csv')

    assert_equal expected_db_data, JSON.parse(QueryService.new.get_tests)
  end

  def test_insert_data_multiple_times
    require './services/query_service'
    import_service = ImportService.new
    import_service.create_table
    expected_db_data = JSON.parse(File.read('./tests/support/test_multiple_insert_db_data.json'))

    import_service.insert File.read('./tests/support/test_multiple_insert_data1.csv')
    import_service.insert File.read('./tests/support/test_multiple_insert_data2.csv')

    assert_equal expected_db_data, JSON.parse(QueryService.new.get_tests)
  end

  def test_insert_data_no_table
    assert_raise(PG::UndefinedTable) { ImportService.new.insert File.read('./tests/support/test_data.csv') }
  end

  def test_insert_data_invalid
    import_service = ImportService.new
    import_service.create_table

    assert_raise(PG::ProtocolViolation) { import_service.insert File.read('./tests/support/test_invalid_data.csv') }
  end
end
