require './services/csv_service'

CsvService.new('./data.csv', 'db').import
