class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("mail_sub_act")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t("mail_sub_reset")
  end
end
