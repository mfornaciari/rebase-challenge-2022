require 'test/unit'
require 'pg'
require './services/import_from_csv_service'

class TestImportFromCsv < Test::Unit::TestCase
  def test_import_from_csv
    data_from_csv = CSV.read('./tests/test_data.csv', headers: true, col_sep: ';').map(&:fields)
    connection = PG.connect dbname: 'medical_records', host: 'test-db', user: 'user', password: 'password'

    ImportFromCsvService.new('./tests/test_data.csv', 'test-db').import_from_csv
    data_from_database = connection.exec('SELECT * FROM exams').map(&:values)
    connection.close

    assert_equal data_from_database, data_from_csv
  end
end
