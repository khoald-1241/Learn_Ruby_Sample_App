class UsersController < ApplicationController
  include Pagy::Backend

  before_action :logged_in_user, except: %i(show new create)
  before_action :find_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :are_you_admin, only: :destroy

  def show
    @pagy, @microposts = pagy @user.microposts.newest,
                              items: Settings.post.items_5
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "check_mail_to_act"
      redirect_to root_url
    else
      flash.now[:danger] = t("signup_failed")
      render :new
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = t "profile_updated"
      redirect_to @user
    else
      flash.now[:success] = t "profile_updated_fail"
      render :edit
    end
  end

  def index
    @pagy, @users = pagy User.all, items: Settings.u_help.users_10
  end

  def destroy
    if @user.destroy
      flash[:success] = t "user_deleted"
    else
      flash[:danger] = t "delete_fail"
    end
    redirect_to users_url
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  # Confirms the correct user.
  def correct_user
    return if current_user? @user

    flash[:danger] = t "can_not_access"
    redirect_to root_path
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "users_not_found"
    redirect_to root_path
  end

  def are_you_admin
    return if current_user.admin

    flash[:danger] = t "not_ad"
    redirect_to root_path
  end
end
