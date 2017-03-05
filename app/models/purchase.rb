class Purchase < ActiveRecord::Base
  belongs_to :user
  has_many :purchase_items
  has_many :items, through: :purchase_item
end
