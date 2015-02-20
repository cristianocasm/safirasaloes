class AddHashtagToProfessional < ActiveRecord::Migration
  def change
    add_column :professionals, :hashtag, :string
  end
end
