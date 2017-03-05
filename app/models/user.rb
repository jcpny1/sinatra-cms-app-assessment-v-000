class User < ActiveRecord::Base
 has_secure_password
 has_many  :purchases
 validates :username, :password_digest, :name, :email, presence: true
 validates :username, uniqueness: true

  def slug
    ApplicationController.slug(self.username)
  end

  def self.find_by_slug(slug)
    mod_slug = slug.downcase
    User.all.detect { |user| user.slug.downcase == mod_slug }
  end

end
