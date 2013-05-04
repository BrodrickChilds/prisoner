class AddCompletionTimeToUser < ActiveRecord::Migration
  def change
    add_column :users, :completion_time, :integer
  end
end
