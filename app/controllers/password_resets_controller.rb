class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, :check_expiration, only: %i(edit update)

  def new; end

  def edit; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "reset_pass_send"
      redirect_to root_url
    else
      flash.now[:danger] = t "email_not_found"
      render :new
    end
  end

  def update
    if user_params[:password].blank?
      @user.errors.add(:password, t("pass_not_empty"))
      render :edit
    elsif @user.update user_params
      log_in @user
      flash[:success] = t "pass_reset_success"
      redirect_to @user
    else
      flash[:success] = t "pass_reset_fail"
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def load_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t "can_not_find_u"
    redirect_to new_password_reset_url
  end

  def valid_user
    unless  @user&.activated &&
            @user&.authenticated?(:reset, params[:id])
      flash[:danger] = t "act_invalid"
      redirect_to root_url
    end
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "pass_reset_expire"
    redirect_to new_password_reset_url
  end
end
