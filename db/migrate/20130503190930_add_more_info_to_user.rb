class AddMoreInfoToUser < ActiveRecord::Migration
  def change
    add_column :users, :birth_date, :string
    remove_column :users, :age
  end
end
