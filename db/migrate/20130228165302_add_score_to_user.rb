class AddScoreToUser < ActiveRecord::Migration
  def change
    add_column :users, :score, :integer
    add_column :users, :latest_stage, :integer
  end
end
