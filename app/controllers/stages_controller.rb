class StagesController < ApplicationController
  def index
    logger.info "got to index stages"
    @stages = Stage.order("level")
    @stage_ids = @stages.map { |stage| stage.level }
    @games_and_stages = []
    @stages.each do |stage|
      games = stage.games.where(:user_id => current_user.id, :complete => false)
      @games_and_stages.append({:stage => stage, :games => games.size})
    end
    unless current_user.has_info
      current_user.update_information(graph.get_object("me"))
    end
    if current_user.time_left < 1
      current_user.reset
    end
    unseen_games = current_user.opp_games.where(:seen_bit => false, :complete => true)
    @unseen_count = unseen_games.size

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @stages }
    end
  end

  # GET /stages/1
  # GET /stages/1.json
  def show
    @game = Game.new
    @stage = Stage.find(params[:id])
    @stages = Stage.order("level")
    @games_and_stages = []
    
    logger.info "got to show stages"
    @stages.each do |stage|
      games = stage.games.where(:user_id => current_user.id, :complete => false)
      @games_and_stages.append({:stage => stage, :games => games.size})
    end
    
    @graph = graph
    @games = @stage.games.where(:user_id => current_user.id, :complete => false) 
    @picture = 'Inmate.jpg'
    @result_games = current_user.result_games(@stage.level)
    
    @result_games.each do |game|
      game.seen
    end
    
    @friend_ids = User.gen_opponents(current_user, graph, 1)
    session[:level] = @stage.level
    
    if current_user && @stage.level == 1 && Game.where(:complete => false, :stage_id => 1).count < 1
      Game.generate_tutorial(current_user, @stage.id)
    elsif current_user && @stage.level == 2 && Bot.challenge(current_user.id, @stage.level) && Game.where(:complete => false, :stage_id => 2).count < 1 && Bot.challenge(current_user.id, @stage.level)
      Game.generate_bot1(current_user, @stage.id)
    elsif current_user && @stage.level == 3 && Bot.update_gradual(current_user.id, @stage.level) && Game.where(:complete => false, :stage_id => 3).count < 1 && Bot.challenge(current_user.id, @stage.level)
      Game.generate_bot2(current_user, @stage.id)
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @stage }
    end
  end

  # GET /stages/new
  # GET /stages/new.json
  def new
    logger.info "got to new stages"
    @stage = Stage.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @stage }
    end
  end

  # GET /stages/1/edit
  def edit
    logger.info "got to edit stages"
    @stage = Stage.find(params[:id])
  end

  # POST /stages
  # POST /stages.json
  def create
    logger.info "got to create stages"
    @stage = Stage.new(params[:stage])

    respond_to do |format|
      if @stage.save
        format.html { redirect_to @stage, :notice => 'Stage was successfully created.' }
        format.json { render :json => @stage, :status => :created, location: @stage }
      else
        format.html { render :action => "new" }
        format.json { render :json => @stage.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /stages/1
  # PUT /stages/1.json
  def update
    logger.info "got to update stages"
    @stage = Stage.find(params[:id])

    respond_to do |format|
      if @stage.update_attributes(params[:stage])
        format.html { redirect_to @stage, :notice => 'Stage was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @stage.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /stages/1
  # DELETE /stages/1.json
  def destroy
    logger.info "got to update stages"
    @stage = Stage.find(params[:id])
    @stage.destroy

    respond_to do |format|
      format.html { redirect_to stages_url }
      format.json { head :no_content }
    end
  end
end
