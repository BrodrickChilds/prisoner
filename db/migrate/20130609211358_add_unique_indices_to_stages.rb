class AddUniqueIndicesToStages < ActiveRecord::Migration
  def change
  	add_index :stages, :name
  end
end
