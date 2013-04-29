class UsersController < ApplicationController
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
end
