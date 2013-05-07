class UsersController < ApplicationController
  helper_method :sort_column, :sort_direction
  def index
    friend_ids = current_user.friend_ids(graph)
    if Rails.env.production?
      @friends = User.where("name ilike ?", "%#{params[:q]}%").where(:id => friend_ids)
    else
      @friends = User.where("name like ?", "%#{params[:q]}%").where(:id => friend_ids)
    end
    @friends = @friends.map(&:attributes)
    @friends.each do |friend|
      friend[:url] = graph.get_picture(friend["uid"].to_i)
      friend_obj = User.find(friend["id"])
      friend[:last_five] = friend_obj.last_five(session[:level])
    end
    respond_to do |format|
      format.html
      format.json { render :json => @friends }
    end
  end

  def show
    @user = User.find(params[:id])
    @picture = graph.get_picture(@user.uid)
    @graph = graph
    show_info = current_user.same_parity?(@user)
    respond_to do |format|
      if show_info
        format.json { render :json => {:user => @user, :url => @picture, :last_five => @user.last_five(session[:level]), :time_left => @user.time_left, :show_info => true}  }
      else
        format.json { render :json => {:user => @user, :url => @picture, :show_info => false} }
      end
      format.html
    end
  end

  def leaders
    if params[:facebook] == "yes"
      @leaders = current_user.facebook_friends(graph, current_user)
    else
      @leaders = User.where("score > ?", -500)
    end
    if params[:completed] == "yes"
      @leaders = @leaders.where("completion_time > ?", 0)
    end
    unless sort_column == "time_left"
      @leaders = @leaders.order(sort_column + ' ' + sort_direction)
    else
      inversion = 1
      if sort_direction == "desc"
        inversion = -1
      end
      @leaders = @leaders.sort_by { |u| u.time_left*inversion }
    end
    @graph = graph
  end

  def random
    @user = User.random_user(current_user)
    @picture = graph.get_picture(@user.uid)
    show_info = current_user.same_parity?(@user)
    respond_to do |format|
      if show_info
        format.json { render :json => {:user => @user, :url => @picture, :last_five => @user.last_five(session[:level]), :time_left => @user.time_left, :show_info => true}  }
      else
        format.json { render :json => {:user => @user, :url => @picture, :show_info => false} }
      end
      format.html
    end
  end

  def sort_column
    %w[completion_time time_left name].include?(params[:sort]) ?  params[:sort] : "time_left"
  end

  def sort_direction
    %w[asc desc].include?(params[:order]) ?  params[:order] : "asc"
  end
end
