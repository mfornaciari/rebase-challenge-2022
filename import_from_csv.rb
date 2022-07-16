require './services/import_service'

import_service = ImportService.new(File.read('./data.csv'))
import_service.create_table
import_service.insert_data
