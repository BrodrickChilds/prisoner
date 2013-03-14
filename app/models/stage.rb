class Stage < ActiveRecord::Base
  attr_accessible :level, :name
  has_many :games
end
