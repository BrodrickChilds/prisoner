class GamesController < ApplicationController
  
  def waiting_responses
    @games = current_user.opp_games.where(:seen_bit => false, :complete => true)
  end

  def respond
    @game = Game.find(params[:game_id])
    if @game.resolve(params[:strategy], @game.user, @game.opponent, graph)
      if @game.user.update_score(@game, 0) && @game.opponent.update_score(@game, 1)
        respond_to do |format|
          format.html { redirect_to game_results_path }
          format.js { render :partial => "games/response", :locals => {:game => @game, :user => User.opponent_name(@game.user, current_user), :opp => User.opponent_name(@game.opponent, current_user)}, :layout => false }
        end
      else
        redirect_to game_path(@game)
      end
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
    game.user_id ||= params[:uid]
    game.complete = false
    game.seen_bit = false
    game.opp_id = current_user.id
    exists = Game.where(:opp_id => game.opp_id, :user_id => game.user_id, :stage_id => game.stage_id, :complete => false).length > 0
    respond_to do |format|
      if game.user_id != game.opp_id && game.stage.level > 1 && !exists
        if game.save
          format.html { redirect_to game.stage, notice: 'Game was successfully created.' }
          format.js { render :partial => 'games/blank', :locals => {:success => true} }
        end
      else
        game.delete
        format.html { redirect_to new_game_path, :notice => "Game could not be created.  You can't challenge the same user more than once before he responds!" }
        if game.stage.level == 1
          format.js { render :partial => 'games/blank', :locals => {:success => false, :message => "level"} }
        elsif exists
          format.js { render :partial => 'games/blank', :locals => {:success => false, :message => "duplicate"} }
        else
          format.js { render :partial => 'games/blank', :locals => {:success => false, :message => "failure"} }
        end
      end
    end
  end

  def destroy
    game = Game.find(params[:id])
    game.delete
  end
end
