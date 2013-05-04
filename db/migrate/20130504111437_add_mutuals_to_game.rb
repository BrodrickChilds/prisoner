class AddMutualsToGame < ActiveRecord::Migration
  def change
    add_column :games, :mutual_friends, :integer
  end
end
