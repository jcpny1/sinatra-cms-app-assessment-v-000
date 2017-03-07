class PurchaseController < ApplicationController

  get '/purchase/:id' do
    redirect '/login' if !logged_in?
    @user = current_user
    @purchases = []
    @purchases << Purchase.find(params[:id])
    erb :'/purchases/purchases'
	end

  get '/purchase' do
    redirect '/login' if !logged_in?
    @user = current_user
    erb :'/purchases/new'
	end

  get '/purchases' do
    redirect '/login' if !logged_in?
    @user = current_user
    @purchases = Purchase.where(user_id: @user.id)
    erb :'/purchases/purchases'
	end

  post '/purchase' do
    puts params
    redirect '/login' if !logged_in?
    purchase = Purchase.new(user_id: session[:user_id])
    (1..3).each do |i|
      if params["select_item_#{i}"] != "0" && params["price_#{i}"].to_f > 0 && params["quantity_#{i}"].to_i > 0
        purchase_item = PurchaseItem.new(purchase_id: purchase.id, item: Item.find(params["select_item_#{i}"]), sale_price: params["price_#{i}"], quantity: params["quantity_#{i}"])
        purchase.purchase_items << purchase_item
      end
    end
    purchase.save
    redirect "/purchase/#{purchase.id}"
  end

end
