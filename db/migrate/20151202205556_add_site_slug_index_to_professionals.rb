class AddSiteSlugIndexToProfessionals < ActiveRecord::Migration
  def change
    add_index :professionals, :site_slug
  end
end
