class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.db.email_format.freeze
  before_save :downcase_email

  validates :name, presence: true, length: {maximum: Settings.db.lenght_100}
  validates :email, presence: true, length: {maximum: Settings.db.lenght_256},
                  format: {with: VALID_EMAIL_REGEX},
                  uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: Settings.db.lenght_6}

  has_secure_password

  private
  def downcase_email
    email.downcase!
  end
end
