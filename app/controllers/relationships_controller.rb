class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :find_user_to_follow, only: :create
  before_action :relationship_load, :find_user_to_unfollow, only: :destroy

  def create
    current_user.follow(@user)
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def destroy
    current_user.unfollow(@user)
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  private
  def find_user_to_follow
    @user = User.find_by(id: params[:followed_id])
    return if @user

    flash[:danger] = t "users_not_found"
    redirect_to root_url
  end

  def relationship_load
    @relationship = Relationship.find_by(id: params[:id])
    return if @relationship

    flash[:danger] = t "relationship_not_found"
    redirect_to root_url
  end

  def find_user_to_unfollow
    @user = @relationship.followed
    return if @user

    flash[:danger] = t "users_not_found"
    redirect_to root_url
  end
end
