class Game < ActiveRecord::Base
  attr_accessible :user_id, :user_tokens, :complete, :opp_id, :opp_strat, :seen_bit, :stage, :user_strat, :stage_id, :user_time_left, :opp_time_left, :user_history, :opp_history, :fb_friend, :same_parity, :mutual_friends
  attr_reader :user_tokens
  belongs_to :user, :class_name => "User"
  belongs_to :opponent, :class_name => "User", :foreign_key => "opp_id"
  belongs_to :stage

  def self.generate_tutorial(user, stage_id)
    if user.time_left == 250
      game = Game.new(user_id: user.id, stage_id: stage_id, opp_id: user.id, user_strat: false, opp_strat: [true, false].sample, complete: false, seen_bit: false) 
      game.save
    else
      recent_game = Game.where("user_id = ? OR opp_id = ?", user.id, user.id).order("updated_at DESC").limit(1)
      opp_TFT = recent_game.pluck(:user_strat)
      if opp_TFT == [true]
        game = Game.new(user_id: user.id, stage_id: stage_id, opp_id: user.id, user_strat: false, opp_strat: true, complete: false, seen_bit: false) 
        game.save
      else
        game = Game.new(user_id: user.id, stage_id: stage_id, opp_id: user.id, user_strat: true, opp_strat: false, complete: false, seen_bit: false) 
        game.save
      end
    end
  end

  def self.generate_bot1(user, stage_id)
    if user.time_left == 250
      game = Game.new(user_id: user.id, stage_id: stage_id, opp_id: 1 , user_strat: false, opp_strat: [true, false].sample, complete: false, seen_bit: false) 
      game.save
    else
      recent_game = Game.where("user_id = ? OR opp_id = ?", user.id, user.id).order("updated_at DESC").limit(1)
      opp_TFT = recent_game.pluck(:user_strat)
      if opp_TFT == [true]
        game = Game.new(user_id: user.id, stage_id: stage_id, opp_id: 1, user_strat: false, opp_strat: true, complete: false, seen_bit: false) 
        game.save
      else
        game = Game.new(user_id: user.id, stage_id: stage_id, opp_id: 1, user_strat: true, opp_strat: false, complete: false, seen_bit: false) 
        game.save
      end
    end 
  end

  def self.generate_bot2(user, stage_id)
    if user.time_left == 250
      game = Game.new(user_id: user.id, stage_id: stage_id, opp_id: 1, user_strat: false, opp_strat: [true, false].sample, complete: false, seen_bit: false) 
      game.save
    else
      recent_game = Game.where("user_id = ? OR opp_id = ?", user.id, user.id).order("updated_at DESC").limit(1)
      opp_TFT = recent_game.pluck(:user_strat)
      if opp_TFT == [false] and Bot.find(:all, :conditions => ["user_id = ? AND stage_id = ?", user, stage_id])[0].gradual==0
        game = Game.new(user_id: user.id, stage_id: stage_id, opp_id: 1, user_strat: false, opp_strat: false, complete: false, seen_bit: false) 
        game.save
      elsif opp_TFT == [true] and Bot.find(:all, :conditions => ["user_id = ? AND stage_id = ?", user, stage_id])[0].gradual==0
        found = Bot.find(:all, :conditions => ["user_id = ? AND stage_id = ?", user, stage_id])[0]
        num_betrays = Game.where("user_id = ? AND stage_id = ? AND user_strat = ?", user, stage_id, true).count
        found.gradual = num_betrays
        found.save
        game = Game.new(user_id: user.id, stage_id: stage_id, opp_id: 1, user_strat: false, opp_strat: true, complete: false, seen_bit: false) 
        game.save
      else
        game = Game.new(user_id: user.id, stage_id: stage_id, opp_id: 1, user_strat: true, opp_strat: true, complete: false, seen_bit: false) 
        found = Bot.find(:all, :conditions => ["user_id = ? AND stage_id = ?", user, stage_id])[0]
        found.gradual -= 1
        found.save
        game.save
      end
    end 
  end


  def user_tokens=(ids)
    friend_ids = ids.split(",")
  end

  def resolve(strat, user, opponent, graph, mutuals)    
    if complete == false
      if stage_id == 1
        update_attributes(:user_strat => strat, :complete => true, :fb_friend => User.facebook_friends?(opponent.id, graph), :same_parity => user.same_parity?(opponent), :seen_bit => true)
      else
        update_attributes(:user_strat => strat, :complete => true, :user_time_left => user.time_left, :opp_time_left => opponent.time_left, :user_history => user.last_five(stage_id), :opp_history => opponent.last_five(stage_id), :fb_friend => User.facebook_friends?(opponent.id, graph), :same_parity => user.same_parity?(opponent), :mutual_friends => mutuals)
      end
    end
  end
  
  def seen
    update_attributes(:seen_bit => true)
  end    

end



