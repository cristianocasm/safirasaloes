class AddAttributesToProfessionals < ActiveRecord::Migration
  def change
    add_column :professionals, :nome, :string
    add_column :professionals, :telefone, :string
    add_column :professionals, :cep, :string
    add_column :professionals, :rua, :string
    add_column :professionals, :numero, :string
    add_column :professionals, :bairro, :string
    add_column :professionals, :cidade, :string
    add_column :professionals, :estado, :string
    add_column :professionals, :complemento, :string
    add_column :professionals, :profissao, :string
    add_column :professionals, :local_trabalho, :string
    add_column :professionals, :plan_id, :integer
    add_index :professionals, :plan_id
    add_column :professionals, :status_id, :integer
    add_index :professionals, :status_id
  end
end
