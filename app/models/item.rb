class Item < ActiveRecord::Base
  belongs_to :category
  has_many :purchase_items
  has_many :purchases, through: :purchase_items
  validates  :name, :price, :category_id, presence: true
  validates :name, uniqueness: true
  validates :name, uniqueness: { scope: :category, message: "unique name within category" }
end
