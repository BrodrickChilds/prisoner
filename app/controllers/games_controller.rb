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
    @opp_user = User.find(@game.opp_id)
    @opponent = User.opponent_name(@opp_user, current_user)
  end

  def waiting_responses
    @games = current_user.opp_games.where(:seen_bit => false, :complete => true)
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
    @opp_user = User.find(@game.opp_id)
    @opp = User.opponent_name(@opp_user, current_user)
    @user = User.find(@game.user_id)
    @user = @user.name
    if @game.opponent == current_user
      @game.seen
    end
  end

  def new
    @stage = params[:level]
    @game = Game.new
  end

  def create
    game = Game.create(params[:game])
    game.user_id = params[:game][:user_tokens]
    print params[:game]
    game.complete = false
    game.seen_bit = false
    game.opp_id = current_user.id
    if game.save && game.user_id != game.opp_id
      redirect_to stages_path
    else
      redirect_to new_game_path, :notice => "Game could not be created, make sure you're not challenging yourself!"
    end
  end

  def destroy
    game = Game.find(params[:id])
    game.delete
  end
end
