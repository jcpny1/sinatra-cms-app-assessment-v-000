class PurchaseController < ApplicationController

  get '/purchases' do
    redirect '/login' if !logged_in?
    @user = current_user
    if session[:purchases]
      @purchases = session[:purchases]
      session.delete(:purchases)
    else
      @purchases = Purchase.where(["user_id = ?", "#{@user.id}"])
    end
    erb :'/purchases/purchases'
	end

  get '/purchase/:id/delete' do
    redirect '/login' if !logged_in?
    @user = current_user
    @purchase = Purchase.where(["id = ? and user_id = ?", "#{params[:id]}", "#{@user.id}"])
    halt(404) if @purchase.size == 0
    @purchase.first.delete
    redirect '/purchases'
  end

  get '/purchase/:id' do                       # Adding another level to the path seems to break style.css, so redirect to /purchases instead.
    redirect '/login' if !logged_in?
    user = current_user
    session[:purchases] = Purchase.where(["id = ? and user_id = ?", "#{params[:id]}", "#{user.id}"])
    redirect '/purchases'
	end

  get '/purchase' do
    redirect '/login' if !logged_in?
    @user = current_user
    erb :'/purchases/new'
	end

  post '/purchase' do
    redirect '/login' if !logged_in?
    @user = current_user
    purchase = Purchase.new(user_id: @user.id)
    purchase_item = nil
    (1..3).each do |i|
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
end
