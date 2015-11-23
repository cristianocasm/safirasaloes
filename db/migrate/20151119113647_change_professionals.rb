class ChangeProfessionals < ActiveRecord::Migration
  def change
    rename_column :professionals, :site, :site_slug
    remove_column :professionals, :local_trabalho
    remove_column :professionals, :pagina_facebook
  end
end
