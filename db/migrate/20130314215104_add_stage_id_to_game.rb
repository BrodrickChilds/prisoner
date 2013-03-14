class AddStageIdToGame < ActiveRecord::Migration
  def change
    add_column :games, :stage_id, :integer
    add_index :games, :stage_id
    add_index :games, :user_id
    add_index :games, :opp_id
  end
end
