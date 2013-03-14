class GamesController < ApplicationController
  def create
  end
  
  def index
    @games = Game.where(:user_id => current_user.id, :complete => false)
    if current_user && current_user.latest_stage == 1 && @games.size == 0
      Game.generate_tutorial(current_user)
    end
  end

  def show
    @game = Game.find(params[:id])
    if @game.opp_id == @game.user_id
      @opponent = "AI"
    else
      @opponent = User.find(@game.opp_id)
      @opponent = @opponent.name
    end
  end

  def respond
    @game = Game.find(params[:game_id])
    if @game.resolve(params[:strategy])
      redirect_to game_results_path
    else
      redirect_to game_path(@game)
    end
  end

  def results
    @game = Game.find(params[:game_id])
    @opp = User.find(@game.opp_id)
    @opp = @opp.name
    @user = User.find(@game.user_id)
    @user = @user.name
  end

  def new
    @stage = params[:level]
    @game = Game.new
  end

  def create
    game = Game.create(params[:game])
    game.complete = false
    game.seen_bit = false
    game.opp_id = current_user.id
    if game.save
      redirect_to stages_path
    else
      redirect_to new_game_path, :notice => "Game could not be created"
    end
  end

  def destroy
    game = Game.find(params[:id])
    game.delete
  end
end
