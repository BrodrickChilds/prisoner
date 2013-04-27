class Game < ActiveRecord::Base
  attr_accessible :user_id, :user_tokens, :complete, :opp_id, :opp_strat, :seen_bit, :stage, :user_strat, :stage_id, :user_time_left, :opp_time_left, :user_history, :opp_history, :fb_friend
  attr_reader :user_tokens
  belongs_to :user, :class_name => "User"
  belongs_to :opponent, :class_name => "User", :foreign_key => "opp_id"
  belongs_to :stage

  def self.generate_tutorial(user, stage_id)
    game = Game.new(user_id: user.id, stage_id: stage_id, opp_id: user.id, user_strat: false, opp_strat: [true, false].sample, complete: false, seen_bit: false) 
    game.save
  end

  def user_tokens=(ids)
    friend_ids = ids.split(",")
  end

  def resolve(strat, user, opponent, graph)    
    if user_id%2 == opp_id%2
      update_attributes(:user_strat => strat, :complete => true, :user_time_left => user.score, :opp_time_left => opponent.score, :user_history => user.last_five(stage_id), :opp_history => opponent.last_five(stage_id), :fb_friend => user.facebook_friends?(opponent.id, graph))
    else
      update_attributes(:user_strat => strat, :complete => true)
    end
  end
  
  def seen
    update_attributes(:seen_bit => true)
  end    

end



