class CreateTakenSteps < ActiveRecord::Migration
  def change
    create_table :taken_steps do |t|
      t.integer :professional_id
      t.boolean :tela_cadastro_contato_acessada, default: false
      t.boolean :contato_cadastrado, default: false
      t.boolean :tela_cadastro_servico_acessada, default: false
      t.boolean :servico_cadastrado, default: false
      t.boolean :tela_cadastro_horario_acessada, default: false
      t.boolean :horario_cadastrado, default: false

      t.timestamps
    end
    add_index :taken_steps, :professional_id

    # Criando um registro na tabela 'taken_step' para cada
    # profissional já cadastrado no sistema
    Professional.all.each { |pr| pr.build_taken_step.save }
  end
end
