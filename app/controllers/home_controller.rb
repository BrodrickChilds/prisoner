class HomeController < ApplicationController

  def index
  	if current_user
  	  @games = Game.where(:user_id => current_user.id, :seen_bit => false)
  	end
  end

end
