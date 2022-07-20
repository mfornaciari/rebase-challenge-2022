require 'csv'
require 'pg'

class ImportService

  def initialize(db)
    @connection = PG.connect dbname: 'medical_records', host: db, user: 'user', password: 'password'
  end

  def create_table
    @connection.exec(
      %q{
        CREATE TABLE IF NOT EXISTS exams (
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

  def drop_table
    @connection.exec('DROP TABLE IF EXISTS exams')
  end

  def insert(data)
    @connection.exec_params(
      %q{ INSERT INTO exams VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16) },
      data
    )
  end
end
