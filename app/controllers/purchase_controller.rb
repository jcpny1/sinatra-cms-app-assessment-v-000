class PurchaseController < ApplicationController

  get '/purchases' do
    redirect '/login' if !logged_in?
    @user = current_user
    @purchases = @user.purchases
    erb :'/purchases/index'
	end

  get '/purchase-workaround' do            # More than one level on the get path breaks css styling, so redirect to /purchases as a workaround.
    redirect '/login' if !logged_in?
    @user = current_user
    if session[:edit]
      @purchase = @user.purchases.find_by(id: session[:edit])
      session.delete(:edit)
      !@purchase.nil? ? (erb :'/purchases/edit') : (redirect '/purchases')
    elsif session[:show]
      @purchases = [@user.purchases.find_by(id: session[:show])]
      session.delete(:show)
      @purchases.size > 0 ? (erb :'/purchases/index') : (redirect '/purchases')
    end
  end

  get '/purchase/:id/delete' do            # More than one level on the get path breaks css styling, so redirect to /purchases as a workaround.
    redirect '/login' if !logged_in?
    purchase = current_user.purchases.find_by(params[:id])
    purchase.destroy if !purchase.nil?
    redirect '/purchases'
  end

  get '/purchase/:id/edit' do              # More than one level on the get path breaks css styling, so redirect to /purchases as a workaround.
    redirect '/login' if !logged_in?
    session[:edit] = params[:id]
    redirect '/purchase-workaround'
  end

  get '/purchase/:id' do                   # More than one level on the get path breaks css styling, so redirect to /purchases as a workaround.
    redirect '/login' if !logged_in?
    session[:show] = params[:id]
    redirect '/purchase-workaround'
# @user = current_user
# @purchases = [@user.purchases.find_by(id: params[:id])]
# erb :'/purchases/index'
	end

  get '/purchase' do
    redirect '/login' if !logged_in?
    @user = current_user
    erb :'/purchases/new'
	end

  post '/purchase' do
    redirect '/login' if !logged_in?
    user = current_user
    purchase = Purchase.new(user_id: user.id)
    purchase_item = nil
    (0..2).each do |i|
      if params["select_item_#{i}"] != "0" && params["price_#{i}"].to_f > 0 && params["quantity_#{i}"].to_i > 0
        purchase.purchase_items << PurchaseItem.new(purchase_id: purchase.id, item: Item.find(params["select_item_#{i}"]), sale_price: params["price_#{i}"], quantity: params["quantity_#{i}"])
      end
    end
    if purchase.purchase_items.size > 0     # duplicate code with patch '/purchase/:id'
      purchase.save
      redirect "/purchase/#{purchase.id}"
    else
      flash[:message] = "A purchase requires at least one purchase item."
      redirect "/purchase/#{purchase.id}/edit"
    end
  end

  patch '/purchase/:id' do
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
    if purchase.purchase_items.size > 0     # duplicate code with post '/purchase'
      purchase.save
      redirect "/purchase/#{purchase.id}"
    else
      flash[:message] = "A purchase requires at least one purchase item."
      redirect "/purchase/#{purchase.id}/edit"
    end
  end
end
