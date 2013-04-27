class AddParityToGame < ActiveRecord::Migration
  def change
    add_column :games, :same_parity, :boolean
  end
end
