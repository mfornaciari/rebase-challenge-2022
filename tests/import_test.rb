require 'test/unit'
require_relative '../app/services/import_service'

class TestImport < Test::Unit::TestCase
  def teardown
    require 'pg'
    connection = PG.connect dbname: 'medical_records', host: 'test-db', user: 'user', password: 'password'
    connection.exec('DROP TABLE IF EXISTS exams')
    connection.close
  end

  def test_create_table_success
    connection = PG.connect dbname: 'medical_records', host: 'test-db', user: 'user', password: 'password'
    columns = CSV.read("#{Dir.pwd}/support/test_data1.csv", headers: true, col_sep: ';').headers

    ImportService.new('test-db').create_table
    db_columns = connection.exec(
      "SELECT column_name FROM information_schema.columns WHERE table_name = 'exams'"
    ).values.flatten
    connection.close

    db_columns.each { |column| assert_include columns, column }
  end

  def test_create_table_already_exists
    connection = PG.connect dbname: 'medical_records', host: 'test-db', user: 'user', password: 'password'
    columns = CSV.read("#{Dir.pwd}/support/test_data1.csv", headers: true, col_sep: ';').headers
    import_service = ImportService.new('test-db')
    import_service.create_table

    import_service.create_table
    db_columns = connection.exec(
      "SELECT column_name FROM information_schema.columns WHERE table_name = 'exams'"
    ).values.flatten
    connection.close

    db_columns.each { |column| assert_include columns, column }
  end

  def test_drop_table_success
    connection = PG.connect dbname: 'medical_records', host: 'test-db', user: 'user', password: 'password'
    import_service = ImportService.new('test-db')
    import_service.create_table

    import_service.drop_table
    table_exists = connection.exec(
      "SELECT EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'exams')"
    ).getvalue(0, 0)
    connection.close

    assert_equal 'f', table_exists
  end

  def test_insert_data_success
    require_relative '../app/services/query_service'
    expected_db_data = JSON.parse(File.read("#{Dir.pwd}/support/test_db_data1.json"))
    import_service = ImportService.new('test-db')
    import_service.create_table

    CSV.foreach("#{Dir.pwd}/support/test_data1.csv", headers: true, col_sep: ';') do |row|
      import_service.insert row.fields
    end

    assert_equal expected_db_data, JSON.parse(QueryService.new.get_tests)
  end

  def test_insert_data_multiple_times
    require_relative '../app/services/query_service'
    import_service = ImportService.new('test-db')
    import_service.create_table
    expected_db_data = JSON.parse(File.read("#{Dir.pwd}/support/test_multiple_insert_db_data.json"))

    CSV.foreach("#{Dir.pwd}/support/test_data1.csv", headers: true, col_sep: ';') do |row|
      import_service.insert row.fields
    end
    CSV.foreach("#{Dir.pwd}/support/test_data2.csv", headers: true, col_sep: ';') do |row|
      import_service.insert row.fields
    end

    assert_equal expected_db_data, JSON.parse(QueryService.new.get_tests)
  end

  def test_insert_data_no_table
    import_service = ImportService.new('test-db')

    CSV.foreach("#{Dir.pwd}/support/test_data1.csv", headers: true, col_sep: ';') do |row|
      assert_raise(PG::UndefinedTable) { import_service.insert row.fields }
    end
  end

  def test_insert_data_invalid
    import_service = ImportService.new('test-db')
    import_service.create_table

    CSV.foreach("#{Dir.pwd}/support/test_invalid_data.csv", headers: true, col_sep: ';') do |row|
      assert_raise(PG::ProtocolViolation) { import_service.insert row.fields }
    end
  end
end
