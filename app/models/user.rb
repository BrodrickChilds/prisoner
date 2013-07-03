class User < ActiveRecord::Base
  #before_save :default_values
  attr_accessible :name, :oauth_expires_at, :oauth_token, :provider, :uid, :latest_stage, :score, :same_parity, :birth_date, :politics, :gender, :religion, :education, :has_info, :completion_time, :time_spent, :last_reminder,:mturk_key
  has_many :games, :class_name => "Game"
  has_many :opp_games, :class_name => "Game", :foreign_key => "opp_id"
  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.score ||= 350
      user.has_info ||= false
      user.latest_stage = 1
      user.time_spent ||= 0
      user.mturk_key ||= 'Still in prison'
      user.save!
    end
  end

  def self.search(search)
    if search
      where('name LIKE ?', "%#{search}%")
    else
      scoped
    end
  end

  def update_information(profile)
    puts profile
    if profile["education"]
      update_attributes(:birth_date => profile["birthday"], :politics => profile["political"], :religion => profile["religion"], :gender => profile["gender"], :has_info => true, :education => profile["education"][profile["education"].size-1]["name"])
    else
      update_attributes(:birth_date => profile["birthday"], :politics => profile["political"], :religion => profile["religion"], :gender => profile["gender"], :has_info => true)
    end
  end

  def self.random_user(current_user)
    total = User.count
    if User.count > 1
      offset = rand(total)
      user = User.first(:offset => offset)
      while user == current_user
        offset = rand(total)
        user = User.first(:offset => offset)
      end
      return user
    end
        
  end

  def send_reminder?
    if !self.last_reminder || self.last_reminder < 1.day.ago
      return true
    else
      return false
    end
  end

  def reset
    if completion_time && time_spent > completion_time
      update_attributes(:score => 350, :time_spent => 0)
    else
      update_attributes(:completion_time => time_spent, :score => 350, :time_spent => 0)
    end
  end

  def self.get_fb_friends(graph)
    friends = graph.get_connections("me", "friends")
    return friends
  end

  def self.facebook_friends?(friend_id, graph)
    fb_friends = get_fb_friends(graph)
    friend_fbids = fb_friends.map{|friend| friend["id"]}
    return friend_fbids.include?(User.find(friend_id).uid)
  end
  
  def self.facebook_friends(graph, user)
    fb_friends = get_fb_friends(graph)
    friend_fbids = fb_friends.map{|friend| friend["id"]}
    friend_fbids << user.uid
    friends = User.where(:uid => friend_fbids)
    return friends
  end


  def self.friend_ids(graph)
    fb_friends = get_fb_friends(graph)
    friend_fbids = fb_friends.map{|friend| friend["id"]}
    friends = User.where(:uid => friend_fbids)
    friend_ids = friends.map{|friend| friend.id}
    return friend_ids
  end


  def self.gen_opponents(current_user, graph, num)

    friends = friend_ids(graph)
    friend_ids = []
    if friends.length < num
      for i in 0..num-1
        friend_ids.push(random_user(current_user).id)
      end
    else
      for i in 0..num-1
        friend_num = friends.length
        offset = rand(friend_num)
        friend_ids.push(friends[offset])
        friends.delete(friends[offset])
      end
    end
    return friend_ids
    logger.info "finished gen opp"
  end


  def self.opponent_name(opp, user)
    if opp == user
      return "Big Pete"
    else
      return opp.name
    end
  end

  def update_score(game, user_index)
    if game.opp_id == 1 and user_index == 0 and game.stage_id > 1
      Bot.update(game.user_id, game.stage_id)
    end
    if game.user_strat
      if game.opp_strat
        stage_index = 3
      else
        stage_index = 2
      end
    else
      if game.opp_strat == false
        stage_index = 0
      else
        stage_index = 1
      end
    end
    user_update_score = Prisoner::Application::PAYOFF[game.stage.level][stage_index][user_index]
    # Bot.create(:user_id => game.user_id, :stage_id => game.stage_id, :last_challenge => DateTime.current())
    if game.stage.level > 1
      update_attributes(:score => self.score+user_update_score, :time_spent => self.time_spent + 1)
    else
      if games.where("stage_id = ?", 1).count<3
        update_attributes(:score => self.score+user_update_score, :time_spent => self.time_spent + 1)
      end
    end
    if self.time_left() < 1
      self.mturk_key='Was freed and recaptured #FXC'+self.id+rand()
      reset
    end
    save
  end

  def cooperates
    games.where(:user_strat => false, :complete => true).where("stage_id != ?", 1).count + opp_games.where(:opp_strat => false, :complete => true).where("stage_id != ?", 1).count   
  end  

  def betrays
    games.where(:user_strat => true, :complete => true).where("stage_id != ?", 1).count + opp_games.where(:opp_strat => true, :complete => true).where("stage_id != ?", 1).count
  end

  def cooperated_against
    games.where(:opp_strat => false, :complete => true).where("stage_id != ?", 1).count + opp_games.where(:user_strat => false, :complete => true).where("stage_id != ?", 1).count
  end

  def betrayed_against
    games.where(:opp_strat => true, :complete => true).where("stage_id != ?",1).count + opp_games.where(:user_strat => true, :complete => true).where("stage_id != ?",1).count
  end

  def last_five(level)
    recent_games = Game.where("user_id = ? OR opp_id = ?", id, id).where(:complete => true, :stage_id => level).order("updated_at DESC").limit(5)
    recent_game_ids = recent_games.map{ |game| game.id }
    percent_betray = 0
    if recent_games.count>=5
      betray_num = Game.where("user_id = ?", id).where(:id => recent_game_ids, :user_strat => true).count + Game.where("opp_id = ?", id).where(:id => recent_game_ids, :opp_strat => true).count
      percent_betray = (betray_num / 5.0) * 100
    else
      betray_num = Game.where("user_id = ?", id).where(:id => recent_game_ids, :user_strat => true).count + Game.where("opp_id = ?", id).where(:id => recent_game_ids, :opp_strat => true).count
      percent_betray = (betray_num / [recent_games.count, 1].max) * 100
    end
  end
  
  def last_five_same(level, other_id)
    recent_games = Game.where("user_id = ? AND opp_id = ?", id, other_id).where(:complete => true, :stage_id => level).order("updated_at DESC").limit(5)
    recent_opp_games = Game.where("user_id = ? AND opp_id = ?", other_id, id).where(:complete => true, :stage_id => level).order("updated_at DESC").limit(5)
    recent_game_ids = recent_games.map{ |game| game.id }
    recent_opp_game_ids = recent_opp_games.map{ |game| game.id }
    recent_game_ids = recent_game_ids + recent_opp_game_ids
    percent_betray = 0
    if recent_games.count>=5
      betray_num = Game.where("user_id = ?", id).where(:id => recent_game_ids, :user_strat => true).count + Game.where("opp_id = ?", id).where(:id => recent_game_ids, :opp_strat => true).count
      percent_betray = (betray_num / 5.0) * 100
    else
      betray_num = Game.where("user_id = ?", id).where(:id => recent_game_ids, :user_strat => true).count + Game.where("opp_id = ?", id).where(:id => recent_game_ids, :opp_strat => true).count
      percent_betray = (betray_num / [recent_games.count, 1].max) * 100
    end
  end

  def same_parity?(opponent)
 #   return id%2 == opponent.id%2
    return true
  end

  def time_left
    score-time_spent
  end

  def result_games(level)
    opp_games.where(:complete => true, :stage_id => level, :seen_bit => false)
  end

private
  def default_values
    self.score ||= 0
    self.latest_stage ||= 1
    self.time_spent ||= 0
  end
end

