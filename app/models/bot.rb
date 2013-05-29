class Bot < ActiveRecord::Base
  attr_accessible :last_challenge, :stage_id, :user_id, :gradual
  has_many :games

  def self.challenge(user, stage)
  	recent_game = Bot.find(:all, :conditions => ["user_id = ? AND stage_id = ?", user, stage])
  	if recent_game.length== 0
  		return true
  	else
  		lastplayed = recent_game[0].last_challenge < 1.day.ago
  		return lastplayed
  	end
  end

  def self.update(user, stage)
    recent_game = Bot.find(:all, :conditions => ["user_id = ? AND stage_id = ?", user, stage])
    if recent_game.length== 0
      Bot.create(:user_id => user, :stage_id => stage, :last_challenge => DateTime.current())
    else
      recent_game[0].last_challenge = DateTime.current()
      recent_game[0].save
    end
  end

  def self.update_gradual(user, stage)
    num_played_gradual = Game.where("user_id = ? AND stage_id = ?", user, stage).count
    if num_played_gradual == 0
      Bot.create(:user_id => user, :stage_id => stage, :last_challenge => DateTime.current(), :gradual => 0)
      return true
    else
      return true
    end
  end


end
