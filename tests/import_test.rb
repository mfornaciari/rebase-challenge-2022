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

    ImportService.new(File.read('./tests/support/test_data.csv')).create_table
    db_columns = connection.exec(
      "SELECT column_name FROM information_schema.columns WHERE table_name = 'exams'"
    ).values.flatten
    connection.close

    db_columns.each { |column| assert_include columns, column }
  end

  def test_create_table_already_exists
    connection = PG.connect dbname: 'medical_records', host: 'test-db', user: 'user', password: 'password'
    columns = CSV.read('./tests/support/test_data.csv', headers: true, col_sep: ';').headers
    import_service = ImportService.new(File.read('./tests/support/test_data.csv'))
    import_service.create_table

    import_service.create_table

    db_columns = connection.exec(
      "SELECT column_name FROM information_schema.columns WHERE table_name = 'exams'"
    ).values.flatten
    db_columns.each { |column| assert_include columns, column }
  end

  def test_insert_data_success
    connection = PG.connect dbname: 'medical_records', host: 'test-db', user: 'user', password: 'password'
    csv_data = CSV.read('./tests/support/test_data.csv', headers:true, col_sep: ';').map(&:fields)
    import_service = ImportService.new(File.read('./tests/support/test_data.csv'))
    import_service.create_table

    import_service.insert_data

    db_data = connection.exec('SELECT * FROM exams').values
    assert_equal csv_data, db_data
  end

  def test_insert_data_no_table
    assert_raise(PG::UndefinedTable) { ImportService.new(File.read('./tests/support/test_data.csv')).insert_data }
  end
end
