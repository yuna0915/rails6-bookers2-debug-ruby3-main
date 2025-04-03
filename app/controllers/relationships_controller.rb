class RelationshipsController < ApplicationController
  def create
    @user = User.find(params[:user_id])
    current_user.follow(@user.id)
    redirect_to request.referer
  end

  def destroy
    @user = User.find(params[:user_id])
    current_user.unfollow(@user.id)
    redirect_to request.referer
  end

  def followings
    user = User.find(params[:id])
    @users = user.followings
  end

  def followers
    user = User.find(params[:id])
    @users = user.followers
  end

end
