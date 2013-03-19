class Game < ActiveRecord::Base
  attr_accessible :user_id, :complete, :opp_id, :opp_strat, :seen_bit, :stage, :user_strat, :stage_id
  belongs_to :user
  belongs_to :opponent, :class_name => "User", :foreign_key => "opp_id"
  belongs_to :stage

  def self.generate_tutorial(user, stage_id)
    game = Game.new(user_id: user.id, stage_id: stage_id, opp_id: user.id, user_strat: false, opp_strat: [true, false].sample, complete: false, seen_bit: false) 
    game.save
  end

  def resolve(strat)
    return update_attributes(:user_strat => strat, :complete => true)
  end
end
