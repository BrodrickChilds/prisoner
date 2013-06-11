class AddUniqueIndicesToStages < ActiveRecord::Migration
  def change
  	add_index :stages, :name, :unique => true
  end
end
