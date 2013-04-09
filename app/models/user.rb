class User < ActiveRecord::Base
  #before_save :default_values
  attr_accessible :name, :oauth_expires_at, :oauth_token, :provider, :uid, :latest_stage, :score
  has_many :games, :class_name => "Game"
  has_many :opp_games, :class_name => "Game", :foreign_key => "opp_id"
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

private
  def default_values
    self.score ||= 0
    self.latest_stage ||= 1
  end
end
