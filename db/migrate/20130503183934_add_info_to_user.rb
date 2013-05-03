class AddInfoToUser < ActiveRecord::Migration
  def change
    add_column :users, :age, :integer
    add_column :users, :gender, :string
    add_column :users, :politics, :string
    add_column :users, :religion, :string
    add_column :users, :has_info, :boolean
    add_column :users, :education, :string
  end
end
