require 'test/unit'
require 'csv'
require 'json'
require 'pg'
require 'net/http'

class TestPost < Test::Unit::TestCase
  def test_post_import
    csv_data = File.read('./tests/support/test_post_data.csv')
    connection = PG.connect dbname: 'medical_records', host: 'test-db', user: 'user', password: 'password'
    http = Net::HTTP.new('localhost', 3000)
    request = Net::HTTP::Post.new('/import', 'Content-Type': 'text/csv')
    request.body = csv_data

    response = http.request(request)
    columns_in_db = connection.exec(
      "SELECT column_name FROM information_schema.columns WHERE table_name = 'exams'"
    ).values.flatten
    data_from_db = connection.exec('SELECT * FROM exams').values

    puts data_from_db
    assert_equal '201', response.code
  end
end
