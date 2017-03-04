class CreatePurchases < ActiveRecord::Migration[5.0]
  def change
    create_table :purchases do |t|
      t.belongs_to :user
      t.timestamps
    end
  end
end
