class AddGradualtoBots < ActiveRecord::Migration
  def change
  	add_column :bots, :gradual, :int
  end
end
