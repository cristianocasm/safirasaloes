class RemoveHashtagFromProfessionals < ActiveRecord::Migration
  def change
    remove_column :professionals, :hashtag, :string
  end
end
