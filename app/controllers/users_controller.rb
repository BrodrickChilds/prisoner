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
    end
    respond_to do |format|
      format.html
      format.json { render :json => @friends }
    end
  end

  def show
    @user = User.find(params[:id])
    @graph = graph
  end
end
