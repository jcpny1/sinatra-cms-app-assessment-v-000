class Category < ActiveRecord::Base
  has_many :items
  has_many :purchase_items, through: :item
  validates  :name, presence: true
  validates :name, uniqueness: true
end
