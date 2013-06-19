class CreateBots < ActiveRecord::Migration
  def change
    create_table :bots do |t|
      t.integer :user_id
      t.integer :stage_id
      t.datetime :last_challenge

      t.timestamps
    end
  end
end
