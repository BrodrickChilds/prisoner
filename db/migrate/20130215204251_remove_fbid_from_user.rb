class RemoveFbidFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :fbid
  end

  def down
    add_column :users, :fbid, :integer
  end
end
