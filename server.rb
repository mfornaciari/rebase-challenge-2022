require 'sinatra'
require 'rack/handler/puma'
require 'pg'
require 'csv'
require './services/csv_service'
require './services/query_service'

get '/tests' do
  content = QueryService.new.get_tests
  if content
    content_type :json
    return content
  end

  content_type :text
  'Não há exames registrados'
end

post '/import' do
  db = ENV['APP_ENV'] == 'test' ? 'test-db' : 'db'
  connection = PG.connect dbname: 'medical_records', host: db, user: 'user', password: 'password'

  csv = CSV.new(request.body.read, headers: true, col_sep: ';')
  csv.each do |row|
    connection.exec_params(
      %q{INSERT INTO exams VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16)},
      row.fields
    )
  end

  [201, 'Dados importados com sucesso.']
end

Rack::Handler::Puma.run(
  Sinatra::Application,
  Port: 3000,
  Host: '0.0.0.0'
)
