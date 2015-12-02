class UpdateSiteSlugToSlug < ActiveRecord::Migration
  def change
    rename_column :professionals, :site_slug, :slug
  end
end
