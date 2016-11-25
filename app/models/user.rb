class User < ActiveRecord::Base
  before_save { self.email = email.downcase if !email.nil? }
  before_create :create_remember_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 225},
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }                  
  
  has_secure_password

  def self.new_remember_token
  	SecureRandom.urlsafe_base64
  end

  def self.digest(token)
  	Digest::SHA1.hexdigest(token.to_s)
  end

  private

	  def create_remember_token
	  	self.remember_token = User.digest(User.new_remember_token)
	  end
end
