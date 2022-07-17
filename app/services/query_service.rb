require 'pg'

class QueryService
  def get_tests
    connection = PG.connect dbname: 'medical_records', host: ENV['DB'], user: 'user', password: 'password'
    result = connection.exec('SELECT * FROM "exams"')
    result.map { |tuple| tuple }.to_json
  rescue PG::UndefinedTable
    false
  end
end
