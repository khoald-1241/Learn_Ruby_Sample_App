class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.db.email_format.freeze
  before_save :downcase_email

  validates :name, presence: true, length: {maximum: Settings.db.lenght_100}
  validates :email, presence: true, length: {maximum: Settings.db.lenght_256},
                  format: {with: VALID_EMAIL_REGEX},
                  uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: Settings.db.lenght_6},
                  allow_nil: true

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

  class << self
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  attr_accessor :remember_token

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  def authenticated? remember_token
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  # Forgets a user.
  def forget
    update_column :remember_digest, nil
  end

  private
  def downcase_email
    email.downcase!
  end
end
