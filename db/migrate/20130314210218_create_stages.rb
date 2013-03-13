class CreateStages < ActiveRecord::Migration
  def change
    create_table :stages do |t|
      t.integer :level
      t.string :name

      t.timestamps
    end
  end
end
