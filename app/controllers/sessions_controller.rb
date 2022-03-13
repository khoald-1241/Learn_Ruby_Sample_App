class SessionsController < ApplicationController
  def create
    user = User.find_by email: params[:session][:email].downcase
    # if user&.authenticate params[:session][:password]
    if user.try(:authenticate, params[:session][:password])
      active_user user
    else
      flash.now[:danger] = t "wrong_email_pass"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
