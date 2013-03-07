class HomeController < ApplicationController

  def index
    if current_user
      @user = current_user
      @phase = @user.latest_stage
    end
  end

end
