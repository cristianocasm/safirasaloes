class AddWhatsappToProfessional < ActiveRecord::Migration
  def change
    add_column :professionals, :whatsapp, :string
  end
end
