class PurchaseItem < ActiveRecord::Base
 belongs_to :purchase
 belongs_to :item
 validates  :item_id, :sale_price, :quantity, presence: true
end
