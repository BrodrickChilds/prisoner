class AddLastReminderToUser < ActiveRecord::Migration
  def change
    add_column :users, :last_reminder, :datetime
  end
end
