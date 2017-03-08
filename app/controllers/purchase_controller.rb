class PurchaseController < ApplicationController

  get '/purchases' do
    redirect '/login' if !logged_in?
    @user = current_user
    if session[:edit]
      @purchase = session[:edit]
      session.delete(:edit)
      erb :'/purchases/edit'
    else
      if session[:purchases]
        @purchases = session[:purchases]
        session.delete(:purchases)
      else
        @purchases = Purchase.where(["user_id = ?", "#{@user.id}"])
      end
      erb :'/purchases/purchases'
    end
	end

  get '/purchase/:id/delete' do            # More than one level on the get path breaks css styling, so redirect to /purchases as a workaround.
    redirect '/login' if !logged_in?
    @user = current_user
    @purchases = Purchase.where(["id = ? and user_id = ?", "#{params[:id]}", "#{@user.id}"])
    halt(404) if @purchases.size == 0
    @purchases.first.delete
    redirect '/purchases'
  end

  get '/purchase/:id/edit' do              # More than one level on the get path breaks css styling, so redirect to /purchases as a workaround.
    redirect '/login' if !logged_in?
    @user = current_user
    purchases = Purchase.where(["id = ? and user_id = ?", "#{params[:id]}", "#{@user.id}"])
    halt(404) if purchases.size == 0
    session[:edit] = purchases.first
    redirect '/purchases'
  end

  get '/purchase/:id' do                   # More than one level on the get path breaks css styling, so redirect to /purchases as a workaround.
    redirect '/login' if !logged_in?
    user = current_user
    session[:purchases] = Purchase.where(["id = ? and user_id = ?", "#{params[:id]}", "#{user.id}"])
    redirect '/purchases'
    # @purchases = Purchase.where(["id = ? and user_id = ?", "#{params[:id]}", "#{user.id}"])
    # erb :'/purchases/purchases'
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
        purchase_item = PurchaseItem.new(purchase_id: purchase.id, item: Item.find(params["select_item_#{i}"]), sale_price: params["price_#{i}"], quantity: params["quantity_#{i}"])
        purchase.purchase_items << purchase_item
      end
    end
    if !purchase_item.nil?
      purchase.save
      redirect "/purchase/#{purchase.id}"
    else
      flash[:message] = "At least one row must be filled in completely."
      redirect '/purchase'
    end
  end

  patch '/purchase/:id' do
    redirect '/login' if !logged_in?
    user = current_user
    purchases = Purchase.where(["id = ? and user_id = ?", "#{params[:id]}", "#{user.id}"])
    halt(404) if purchases.size == 0
    purchase = purchases.first

# Flushing out all purchase_items!
# Instead do:
#   step through edited items vs existing items.
#   if existing item and not edited item, then delete existing item.
#   if not existing item and edited item, then new item.
#   if existing item and edited item, compare each field and update, if changed.

    purchase.purchase_items = []
    purchase_item = nil
    (0..2).each do |i|
      if params["select_item_#{i}"] != "0" && params["price_#{i}"].to_f > 0 && params["quantity_#{i}"].to_i > 0
        purchase_item = PurchaseItem.new(purchase_id: purchase.id, item: Item.find(params["select_item_#{i}"]), sale_price: params["price_#{i}"], quantity: params["quantity_#{i}"])
        purchase.purchase_items << purchase_item
      end
    end
    if !purchase_item.nil?
      purchase.save
      redirect "/purchase/#{purchase.id}"
    else
      flash[:message] = "At least one row must be filled in completely."
      redirect "/purchase/#{purchase.id}/edit"
    end
  end
end
