require 'sinatra'
require 'rack/handler/puma'
require 'csv'

get '/tests' do
  ### Example
  # [
  #   [cpf, name, date],
  #   [123, 'Leandro', 2022-01-01'],
  #   [456, 'Ana', 2022-01-02'],
  #   [789, 'Maria', 2022-01-03']
  # ]
  #
  rows = CSV.read("./data.csv", col_sep: ';')

  ### Example
  # [cpf, name, date]
  columns = rows.shift

  ### Example
  # From:  [123, 'Leandro', 2022-01-01']
  # To: { cpf: 123, name: 'Leandro', date: '2022-01-01' }
  rows.map do |row|
    row.each_with_object({}).with_index do |(cell, acc), idx|
      column = columns[idx]
      acc[column] = cell
    end
  end.to_json
end

Rack::Handler::Puma.run(
  Sinatra::Application,
  Port: 3000,
  Host: '0.0.0.0'
)
