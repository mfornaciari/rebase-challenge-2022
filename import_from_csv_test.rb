require 'test/unit'
require 'pg'
require './import_from_csv'

class TestImportFromCsv < Test::Unit::TestCase
  def test_import_from_csv
    data_from_csv = CSV.read('./test_data.csv', headers: true, col_sep: ';').map(&:fields)
    connection = PG.connect dbname: 'medical_records', host: 'database', user: 'user', password: 'password'

    import_from_csv('./test_data.csv')
    data_from_database = connection.exec('SELECT * FROM exams').map(&:values)
    connection.close

    assert_equal data_from_database, data_from_csv
  end
end