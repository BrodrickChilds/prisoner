class GamesController < ApplicationController
  def create
  end
  
  def index
    if current_user && current_user.stage == 1
      Game.generate_tutorial(current_user)
    end
    @games = Game.all
  end

  def show
  end

  def respond
  end
end
