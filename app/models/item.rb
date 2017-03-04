class Item < ActiveRecord::Base
 belongs_to :category
 has_many :purchase_items
 validates  :name, :price, :category_id, presence: true
end
