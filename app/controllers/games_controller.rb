class GamesController < ApplicationController
  def create
  end
  
  def index
    @games = Game.where(:user_id => current_user.id, :seen_bit => false)
    if current_user && current_user.latest_stage == 1 && @games.size == 0
      Game.generate_tutorial(current_user)
    end
    @games = Game.where(:user_id => current_user.id)
  end

  def show
    @game = Game.find(params[:id])
  end

  def respond
  end
end
