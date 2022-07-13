require './services/import_from_csv_service'

ImportFromCsvService.new('./data.csv', 'db').import_from_csv
