class AddSiteAndPaginaFacebookToProfessional < ActiveRecord::Migration
  def change
    add_column :professionals, :site, :string
    add_column :professionals, :pagina_facebook, :string
  end
end
