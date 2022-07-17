require 'sinatra'
require 'rack/handler/puma'
require_relative './services/import_service'
require_relative './services/query_service'

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
  import_service = ImportService.new
  import_service.create_table
  import_service.insert request.body.read
  [201, 'Dados importados com sucesso.']
rescue PG::ProtocolViolation
  [422, 'Formato dos dados incorreto.']
end

Rack::Handler::Puma.run(
  Sinatra::Application,
  Port: 3000,
  Host: '0.0.0.0'
)
