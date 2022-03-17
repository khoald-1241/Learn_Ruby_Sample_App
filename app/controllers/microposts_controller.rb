class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    if @micropost.save
      flash[:success] = t "post_success"
    else
      flash[:danger] = t "post_fail"
      @pagy, @feed_items = pagy(current_user.feed.newest)
    end
    redirect_to root_url
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "post_del_suc"
    else
      flash[:danger] = t "post_del_fail"
    end
    redirect_to request.referer || root_url
  end

  private
  def micropost_params
    params.require(:micropost).permit :content, :image
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:danger] = t "post_inva"
    redirect_to request.referer || root_url
  end
end
