require 'csv'
require 'pg'

class ImportService

  def initialize(data)
    @db = ENV['APP_ENV'] == 'test' ? 'test-db' : 'db'
    @csv = CSV.new(data, headers: true, col_sep: ';')
    @connection = PG.connect dbname: 'medical_records', host: @db, user: 'user', password: 'password'
  end

  def create_table
    @connection.exec "DROP TABLE IF EXISTS exams"
    @connection.exec(
      %q{
        CREATE TABLE exams (
          "cpf" VARCHAR(14),
          "nome paciente" VARCHAR(100),
          "email paciente" VARCHAR(100),
          "data nascimento paciente" DATE,
          "endereço/rua paciente" VARCHAR(100),
          "cidade paciente" VARCHAR(50),
          "estado patiente" VARCHAR(50),
          "crm médico" VARCHAR(10),
          "crm médico estado" VARCHAR(50),
          "nome médico" VARCHAR(100),
          "email médico" VARCHAR(100),
          "token resultado exame" VARCHAR(10),
          "data exame" DATE,
          "tipo exame" VARCHAR(50),
          "limites tipo exame" VARCHAR(10),
          "resultado tipo exame" INTEGER
        )
      }
    )
  end

  def insert_data
    @csv.each do |row|
      @connection.exec_params(
        %q{INSERT INTO exams VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16)},
        row.fields
      )
    end
  end
end
