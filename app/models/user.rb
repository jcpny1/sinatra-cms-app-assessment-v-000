class User < ActiveRecord::Base
  has_secure_password
  has_many  :purchases
  validates :username, :password_digest, :name, :email, presence: true
  validates :username, uniqueness: true
end
