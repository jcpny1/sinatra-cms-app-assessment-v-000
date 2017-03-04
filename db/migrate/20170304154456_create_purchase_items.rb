class CreatePurchaseItems < ActiveRecord::Migration[5.0]
  def change
    create_table :purchase_items do |t|
      t.belongs_to :purchase
      t.belongs_to :item
      t.decimal    :sale_price
      t.integer    :quantity
      t.timestamps
    end
  end
end
