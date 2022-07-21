require 'pg'

class QueryService
  def get_tests
    connection = PG.connect dbname: 'medical_records', host: ENV['DB'], user: 'user', password: 'password'
    result = connection.exec('SELECT * FROM "exams"')
    connection.close
    result.map { |tuple| tuple }.to_json
  rescue PG::UndefinedTable
    false
  end

  def get_tests_token(token)
    connection = PG.connect dbname: 'medical_records', host: ENV['DB'], user: 'user', password: 'password'
    result = connection.exec(%Q{ SELECT * FROM exams WHERE "token resultado exame" = '#{token}' })
    connection.close
    return false if result.cmd_tuples == 0

    patient_columns = ['token resultado exame', 'data exame', 'cpf',
                       'nome paciente', 'email paciente', 'data nascimento paciente']
    physician_columns = ['crm médico', 'crm médico estado', 'nome médico']
    exam_columns = ['tipo exame', 'limites tipo exame', 'resultado tipo exame']
    first_row = result.first
    data = first_row.select { |key, _value| patient_columns.include?(key) }
    data['médico'] = first_row.select { |key, _value| physician_columns.include?(key) }
    data['exames'] = result.map { |row| row.select { |key, _value| exam_columns.include?(key) } }
    data.to_json
  end
end
