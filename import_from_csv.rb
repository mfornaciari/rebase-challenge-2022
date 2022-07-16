require './services/import_service'

import_service = ImportService.new
import_service.drop_table
import_service.create_table
import_service.insert File.read('./data.csv')
