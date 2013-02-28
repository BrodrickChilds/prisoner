class Game < ActiveRecord::Base
  attr_accessible :user_id, :complete, :opp_id, :opp_strat, :seen_bit, :stage, :user_strat

  def generate_tutorial(user)
    game = Game.new(user_id: user.id, stage: 1) 
  end
end
