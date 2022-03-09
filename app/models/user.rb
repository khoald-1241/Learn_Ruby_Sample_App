class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.db.email_format.freeze
  before_save :downcase_email

  validates :name, presence: true, length: {maximum: Settings.db.lenght_100}
  validates :email, presence: true, length: {maximum: Settings.db.lenght_256},
                  format: {with: VALID_EMAIL_REGEX},
                  uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: Settings.db.lenght_6}

  has_secure_password

  # Returns the hash digest of the given string.
  def self.digest string
    cost =  if ActiveModel::SecurePassword.min_cost
              BCrypt::Engine::MIN_COST
            else
              BCrypt::Engine.cost
            end
    BCrypt::Password.create string, cost: cost
  end

  private
  def downcase_email
    email.downcase!
  end
end
