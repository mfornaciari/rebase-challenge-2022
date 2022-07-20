require 'sidekiq'
require 'pg'
require_relative '../services/import_service'

class ImportWorker
  include Sidekiq::Worker

  def perform(csv_data, db)
    import_service = ImportService.new(db)
    import_service.create_table
    import_service.insert(csv_data)
  end
end
