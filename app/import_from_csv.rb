require './sidekiq/import_worker'

CSV.foreach("#{Dir.pwd}/data.csv", headers: true, col_sep: ';') do |row|
  ImportWorker.perform_async(row.fields, 'db')
end
