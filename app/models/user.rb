class User < ActiveRecord::Base
  #before_save :default_values
  attr_accessible :name, :oauth_expires_at, :oauth_token, :provider, :uid, :latest_stage, :score
  has_many :games, :class_name => "Game"
  has_many :opp_games, :class_name => "Game", :foreign_key => "opp_id"
  payoff = prisoner::Application::PAYOFF
  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end

  def get_fb_friends(graph)
    friends = graph.get_connections("me", "friends")
    return friends
  end

  def facebook_friends? (friend_id, graph)
    fb_friends = get_fb_friends(graph)
    friend_ids = fb_friends.map{|friend| friend["id"]}
    return friend_fbids.include?(User.find(friend_id).fbid)
  end

  def friend_ids(graph)
    fb_friends = get_fb_friends(graph)
    friend_fbids = fb_friends.map{|friend| friend["id"]}
    friends = User.where(:uid => friend_fbids)
    friend_ids = friends.map{|friend| friend.id}
    return friend_ids
  end

  def self.opponent_name(opp, user)
    if opp = user
      return "AI"
    else
      return opp.name
    end
  end

private
  def default_values
    self.score ||= 0
    self.latest_stage ||= 1
  end

  def update_score(game, user_index)

    if game.user_strat == false:
      if game.opp_strat == false:
        total_strat = 0
      else:
        total_strat = 1
      end
    else:
      if game.opp_strat == false:
        total_strat = 2
      else:
        total_strat = 3
      end
    end
    update_attributes(:score => score + payoff[game.stage.level][total_strat][user_index]
  
end
