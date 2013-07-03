class AddMturkKeyToUser < ActiveRecord::Migration
  def change
    add_column :users, :mturk_key, :string
  end
end
