class Purchase < ActiveRecord::Base
  belongs_to :user
  has_many :purchase_items
  has_many :items, through: :purchase_items

  def add_item(params, i)
    if params["select_item_#{i}"] != "0" && params["price_#{i}"].to_f > 0 && params["quantity_#{i}"].to_i > 0
      self.purchase_items.new(purchase_id: self.id, item: Item.find(params["select_item_#{i}"]), sale_price: params["price_#{i}"], quantity: params["quantity_#{i}"])
    end
  end
end
