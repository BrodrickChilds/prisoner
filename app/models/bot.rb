class Bot < ActiveRecord::Base
  attr_accessible :last_challenge, :stage_id, :user_id, :gradual
  has_many :games

  def self.challenge(user, stage)
  	recent_game = Bot.where(:user_id => user, :stage_id => stage)
  	if recent_game.count == 0
  		return true
  	else
  		lastplayed = recent_game[0].last_challenge < 3.hours.ago
  		return lastplayed
  	end
  end

  def self.update(user, stage)
    recent_game = Bot.where(:user_id => user, :stage_id => stage)
    if recent_game.count == 0
      Bot.create(:user_id => user, :stage_id => stage, :last_challenge => DateTime.current())
    else
      recent_game[0].last_challenge = DateTime.current()
      recent_game[0].save
    end
  end

  def self.update_gradual(user, stage)
    num_played_gradual = Bot.where(:user_id => user, :stage_id => stage).count
    if num_played_gradual == 0
      Bot.create(:user_id => user, :stage_id => stage, :last_challenge => DateTime.current()-1.day, :gradual => 0)
      return true
    else
      return true
    end
  end


end
