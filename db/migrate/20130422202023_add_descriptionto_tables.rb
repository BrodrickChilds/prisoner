class AddDescriptiontoTables < ActiveRecord::Migration
  def change
  	add_column :stages, :description, :text

  end

end
