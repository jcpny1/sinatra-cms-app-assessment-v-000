class PurchaseController < ApplicationController

  get '/purchases' do
    redirect '/login' if !logged_in?
    @user = current_user
    @purchases = @user.purchases
    erb :'/purchases/index'
	end

  get '/purchases/new' do
    redirect '/login' if !logged_in?
    @user = current_user
    erb :'/purchases/new'
	end

  get '/purchases-workaround' do            # More than one level on the get path breaks css styling, so redirect to /purchases as a workaround.
    redirect '/login' if !logged_in?
    @user = current_user
    if session[:edit]
      @purchase = @user.purchases.find_by(id: session[:edit])
      session.delete(:edit)
      erb :'/purchases/edit' if !@purchase.nil?
    elsif session[:show]
      @purchases = [@user.purchases.find_by(id: session[:show])]
      session.delete(:show)
      erb :'/purchases/index' if !@purchases.first.nil?
    end
  end

  get '/purchases/:id/delete' do            # More than one level on the get path breaks css styling, so redirect to /purchases as a workaround.
    redirect '/login' if !logged_in?
    purchase = current_user.purchases.find_by(id: params[:id])
    purchase.destroy if !purchase.nil?
    redirect '/purchases' if !purchase.nil?
  end

  get '/purchases/:id/edit' do              # More than one level on the get path breaks css styling, so redirect to /purchases as a workaround.
    redirect '/login' if !logged_in?
    session[:edit] = params[:id]
    redirect '/purchases-workaround'
  end

  get '/purchases/:id' do                   # More than one level on the get path breaks css styling, so redirect to /purchases as a workaround.
    redirect '/login' if !logged_in?
    session[:show] = params[:id]
    redirect '/purchases-workaround'
# @user = current_user
# @purchases = [@user.purchases.find_by(id: params[:id])]
# erb :'/purchases/index'
	end

  post '/purchases' do
    redirect '/login' if !logged_in?
    user = current_user
    purchase = Purchase.new(user_id: user.id)
    purchase_item = nil
    (0..2).each do |i|
      if params["select_item_#{i}"] != "0" && params["price_#{i}"].to_f > 0 && params["quantity_#{i}"].to_i > 0
        purchase.purchase_items << PurchaseItem.new(purchase_id: purchase.id, item: Item.find(params["select_item_#{i}"]), sale_price: params["price_#{i}"], quantity: params["quantity_#{i}"])
      end
    end
    if purchase.purchase_items.size > 0     # duplicate code with patch '/purchases/:id'
      purchase.save
      redirect "/purchases/#{purchase.id}"
    else
      flash[:message] = "A purchase requires at least one purchase item."
      redirect "/purchases/#{purchase.id}/edit"
    end
  end

  patch '/purchases/:id' do
    redirect '/login' if !logged_in?
    user = current_user
    purchase = user.purchases.find_by(id: params[:id])

# Flushing out all purchase_items!
# Instead do:
#   step through edited items vs existing items.
#   if existing item and not edited item, then delete existing item.
#   if not existing item and edited item, then add new item.
#   if existing item and edited item, copy edited fields to existing fields.

    purchase.purchase_items = []
    (0..2).each do |i|
      if params["select_item_#{i}"] != "0" && params["price_#{i}"].to_f > 0 && params["quantity_#{i}"].to_i > 0
        purchase.purchase_items << PurchaseItem.new(purchase_id: purchase.id, item: Item.find(params["select_item_#{i}"]), sale_price: params["price_#{i}"], quantity: params["quantity_#{i}"])
      end
    end
    if purchase.purchase_items.size > 0     # duplicate code with post '/purchases'
      purchase.save
      redirect "/purchases/#{purchase.id}"
    else
      flash[:message] = "A purchase requires at least one item."
      redirect "/purchases/#{purchase.id}/edit"
    end
  end
end
