class RemoveStageFromGame < ActiveRecord::Migration
  def up
    remove_column :games, :stage
  end

  def down
    add_column :games, :stage, :integer
  end
end
