class RemovePlanFromProfessionalsTable < ActiveRecord::Migration
  def up
    remove_column :professionals, :plan_id
  end

  def down
    add_column :professionals, :plan_id, :integer
  end
end
