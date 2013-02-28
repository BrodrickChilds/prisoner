class Game < ActiveRecord::Base
  attr_accessible :user_id, :complete, :opp_id, :opp_strat, :seen_bit, :stage, :user_strat

  def generate_tutorial(user)
    game = Game.new(user_id: user.id, stage: 1, opp_id: user.id, user_strat: false, opp_strat: [true, false].sample, complete: false, seen_bit: false) 
  end
end
