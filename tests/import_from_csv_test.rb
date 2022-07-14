require 'test/unit'
require './services/import_from_csv_service'

class TestImportFromCsv < Test::Unit::TestCase
  def test_import_from_csv
    csv_file = CSV.read('./tests/test_data.csv', headers: true, col_sep: ';')
    data_from_csv = csv_file.map(&:fields)
    columns_in_csv = csv_file.headers
    connection = PG.connect dbname: 'medical_records', host: 'test-db', user: 'user', password: 'password'

    ImportFromCsvService.new('./tests/test_data.csv', 'test-db').import_from_csv
    data_from_db = connection.exec('SELECT * FROM exams').values
    columns_in_db = connection.exec(
      "SELECT column_name FROM information_schema.columns WHERE table_name = 'exams'"
    ).values.flatten

    assert_equal data_from_db, data_from_csv
    columns_in_db.each { |column| assert_include columns_in_csv, column }
  end
end
