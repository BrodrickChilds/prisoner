class UsersController < ApplicationController
  def index
    friend_ids = current_user.friend_ids(graph)
    @friends = User.where("name like ?", "%#{params[:q]}%").where(:id => friend_ids)
    respond_to do |format|
      format.html
      format.json { render :json => @friends.map(&:attributes) }
    end
  end

  def show
  end
end
