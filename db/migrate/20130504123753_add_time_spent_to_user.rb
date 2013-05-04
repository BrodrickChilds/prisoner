class AddTimeSpentToUser < ActiveRecord::Migration
  def change
    add_column :users, :time_spent, :integer
  end
end
