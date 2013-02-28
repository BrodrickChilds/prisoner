class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :user_id
      t.integer :stage
      t.integer :opp_id
      t.boolean :user_strat
      t.boolean :opp_strat
      t.boolean :complete
      t.boolean :seen_bit

      t.timestamps
    end
  end
end
