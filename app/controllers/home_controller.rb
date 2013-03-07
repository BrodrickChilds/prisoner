class HomeController < ApplicationController

  def index
    if current_user
      @user = current_user
      @phase = @user.latest_stage
      @games = Game.where(:user_id => current_user.id, :seen_bit => false)
    end
  end

end
