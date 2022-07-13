require 'csv'

def import_from_csv(file_path)
  connection = PG.connect dbname: 'medical_records', host: 'database', user: 'user', password: 'password'
  connection.exec "DROP TABLE IF EXISTS exams"
  connection.exec(
    %q{
      CREATE TABLE exams (
        cpf VARCHAR(14),
        nome_paciente VARCHAR(100),
        email_paciente VARCHAR(100),
        data_nascimento_paciente DATE,
        endereço_rua_paciente VARCHAR(100),
        cidade_paciente VARCHAR(50),
        estado_paciente VARCHAR(50),
        crm_médico VARCHAR(10),
        crm_médico_estado VARCHAR(50),
        nome_médico VARCHAR(100),
        email_médico VARCHAR(100),
        token_resultado_exame VARCHAR(10),
        data_exame DATE,
        tipo_exame VARCHAR(50),
        limites_tipo_exame VARCHAR(10),
        resultado_tipo_exame INTEGER
      )
    }
  )

  CSV.foreach(file_path, headers: true, col_sep: ';') do |row|
  connection.exec_params(
    %q{INSERT INTO exams VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16)},
    row.fields
  )
  end
  connection.close
end
