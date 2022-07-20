require 'sinatra'
require 'rack/handler/puma'
require_relative './services/query_service'
require_relative './sidekiq/import_worker'

get '/tests' do
  content = QueryService.new.get_tests
  if content
    content_type :json
    return content
  end

  content_type :text
  'Não há exames registrados.'
end

post '/import' do
  csv = CSV.parse(request.body.read, headers: true, col_sep: ';')
  return [422, 'Formato dos dados incorreto.'] unless csv.headers.length == 16

  CSV.new(request.body.read, headers: true, col_sep: ';').each do |row|
    ImportWorker.perform_async(row.fields, ENV['DB'])
  end
  [201, 'Dados importados com sucesso.']
end

Rack::Handler::Puma.run(
  Sinatra::Application,
  Port: 3000,
  Host: '0.0.0.0'
)
