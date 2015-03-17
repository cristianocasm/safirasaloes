class AddNomeEmailTelefoneToSchedule < ActiveRecord::Migration
  def change
    add_column :schedules, :nome, :string
    add_column :schedules, :email, :string
    add_column :schedules, :telefone, :string
  end
end
