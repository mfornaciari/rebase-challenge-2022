require 'pg'

class QueryService
  def initialize
      @db = ENV['APP_ENV'] == 'test' ? 'test-db' : 'db'
  end

  def get_tests
    connection = PG.connect dbname: 'medical_records', host: @db, user: 'user', password: 'password'
    result = connection.exec('SELECT * FROM "exams"')
    result.map { |tuple| tuple }.to_json
  rescue PG::UndefinedTable
    false
  end

end