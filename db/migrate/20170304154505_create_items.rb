class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.belongs_to :category
      t.string  :name
      t.decimal :price
      t.timestamps
    end
  end
end
