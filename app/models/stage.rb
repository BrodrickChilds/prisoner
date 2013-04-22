class Stage < ActiveRecord::Base
  attr_accessible :level, :name, :description
  has_many :games
end
