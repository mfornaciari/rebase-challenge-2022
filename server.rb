require 'sinatra'
require 'rack/handler/puma'
require './services/import_service'
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
  import_service = ImportService.new(request.body.read)
  import_service.create_table
  import_service.insert_data
  [201, 'Dados importados com sucesso.']
end

Rack::Handler::Puma.run(
  Sinatra::Application,
  Port: 3000,
  Host: '0.0.0.0'
)
