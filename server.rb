require 'sinatra'
require 'rack/handler/puma'
require 'pg'
require 'csv'
require './services/csv_service'

before do
end

get '/tests' do
  content_type :json

  db = ENV['APP_ENV'] == 'test' ? 'test-db' : 'db'
  connection = PG.connect dbname: 'medical_records', host: db, user: 'user', password: 'password'

  result = connection.exec('SELECT * FROM "exams"')
  result.map { |tuple| tuple }.to_json
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
