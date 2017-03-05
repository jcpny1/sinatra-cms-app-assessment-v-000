categories_list = [
    "Auto",
    "Clothing",
    "Grocery",
    "Medical"
  ]

categories_list.each { |name| Category.create(name: name) }

category_hash = {}
Category.all.each { |c| category_hash[c.name.to_sym] = c }

items_list = {
    "Mobile 10W30" => {
      :price => 4.99,
      :category_id => category_hash[:Auto][:id]
    },
    "Men's Dress Socks, Black, 1pr" => {
      :price => 6.39,
      :category_id => category_hash[:Clothing][:id]
    },
    "Aspirin 100 tablets" => {
      :price => 7.99,
      :category_id => category_hash[:Medical][:id]
    },
    "Aspirin 500 tablets" => {
      :price => 23.99,
      :category_id => category_hash[:Medical][:id]
    }
  }

items_list.each do |name, item_hash|
  item = Item.new(name: name)
  item_hash.each { |attribute, value| item[attribute] = value }
  item.save
end

# Returns the hash digest of the given string.
def User.digest(string)
  cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
  BCrypt::Password.create(string, cost: cost)
end

users_list = {
    "robinhood" => {
      :password_digest => "#{User.digest('dude')}",
      :name => "Robin Hood",
      :email => "rh5131@aol.com"
    }
  }

users_list.each do |username, user_hash|
  user = User.new(username: username)
  user_hash.each { |attribute, value| user[attribute] = value }
  user.save
end

PurchaseItem.delete_all
Purchase.delete_all

Purchase.create(user_id: 1)
PurchaseItem.create(purchase_id: 1, item_id: 1, sale_price: 4.99, quantity: 1)
