# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Stage.create(:id => 1, :level => 1, :name => "Training")
Stage.create(:id => 2, :level => 2, :name => "Kitchen")
Stage.create(:id => 3, :level => 3, :name => "Cell")
Stage.create(:id => 4, :level => 4, :name => "Yard")
Stage.create(:id => 5, :level => 5, :name => "Hospital")
Stage.create(:id => 6, :level => 6, :name => "Office")
