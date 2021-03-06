class UsersController < ApplicationController
  helper_method :sort_column, :sort_direction
  def index
    if Rails.env.production?
      @friends = User.where("name ilike ?", "%#{params[:q]}%")
    else
      @friends = User.where("name like ?", "%#{params[:q]}%")
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
        format.json { render :json => {:user => @user, :url => @picture, :last_five => @user.last_five(session[:level]), :time_left => @user.time_left, :show_info => true, :send_reminder => @user.send_reminder?}  }
        format.html
      else
        format.json { render :json => {:user => @user, :url => @picture, :show_info => false, :send_reminder => @user.send_reminder?} }
        format.html { redirect_to root_path, :flash => {:notice => "You cannot see this user's information" }}
      end
    end
  end

  def leaders
    if params[:facebook] == "yes"
      @leaders = User.facebook_friends(graph, current_user)
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
    if current_user.time_left < 1
      current_user.reset
      format.html { redirect_to root_path, :flash => {:success => "Congrats you have been released, but the police arrested you again, see if you can get out even quicker this time" }}
    end
    @leaders = @leaders.paginate(:per_page => 10, :page => params[:page])
    @graph = graph
  end

  def random
    @user = User.random_user(current_user)
    @picture = graph.get_picture(@user.uid)
    show_info = current_user.same_parity?(@user)
    respond_to do |format|
      if show_info
        format.json { render :json => {:user => @user, :url => @picture, :last_five => @user.last_five(session[:level]), :time_left => @user.time_left, :show_info => true, :send_reminder => @user.send_reminder?}  }
      else
        format.json { render :json => {:user => @user, :url => @picture, :show_info => false, :send_reminder => @user.send_reminder?} }
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

  def update_reminder
    @user = User.find(params[:user_id])
    respond_to do |format|
      format.js { 
        @user.update_attributes(:last_reminder => Time.now) 
        render :nothing => true
      }
    end
  end
end
