require 'sinatra'
require 'rack/handler/puma'
require 'pg'

before do
end

get '/tests' do
  content_type :json

  db = ENV['APP_ENV'] == 'test' ? 'test-db' : 'db'
  connection = PG.connect dbname: 'medical_records', host: db, user: 'user', password: 'password'

  result = connection.exec('SELECT * FROM "exams"')
  result.map { |tuple| tuple }.to_json
end

Rack::Handler::Puma.run(
  Sinatra::Application,
  Port: 3000,
  Host: '0.0.0.0'
)
