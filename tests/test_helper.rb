require 'pg'

  connection = PG.connect dbname: 'medical_records', host: 'test-db', user: 'user', password: 'password'
  connection.exec('DROP TABLE IF EXISTS "exams"')
