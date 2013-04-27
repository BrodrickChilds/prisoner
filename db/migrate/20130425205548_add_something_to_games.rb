class AddSomethingToGames < ActiveRecord::Migration
  def change
  	add_column :games, :user_time_left, :integer
  	add_column :games, :opp_time_left, :integer
  	add_column :games, :user_history, :integer
  	add_column :games, :opp_history, :integer
  	add_column :games, :fb_friend, :boolean
  end
end
