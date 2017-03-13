class PurchaseController < ApplicationController

  get '/purchases' do                       # show all purchases
    redirect '/login' if !logged_in?
    @user = current_user
    @purchases = @user.purchases
    erb :'/purchases/index'
	end

  get '/purchases/new' do                   # enter a new purchase
    redirect '/login' if !logged_in?
    @user = current_user
    erb :'/purchases/new'
	end

  post '/purchases' do                      # save new purchase
    redirect '/login' if !logged_in?
    purchase = Purchase.new(user_id: current_user.id)
    (0..2).each { |i| purchase.add_item(params, i) }
    if save_purchase(purchase)
      redirect "/purchases/#{p.id}"
    else
      redirect '/purchases/new'
    end
  end

  get '/purchases/:id/edit' do              # edit a purchase
    @user = current_user
    @purchase = @user.purchases.find_by(id: params[:id])
    erb :'/purchases/edit' if !@purchase.nil?
  end

  patch '/purchases/:id' do                 # save edited purchase
    redirect '/login' if !logged_in?
    purchase = current_user.purchases.find_by(id: params[:id])
    purchase.purchase_items = []  # Don't do this. Edit existing, add, or delete as needed.
    (0..2).each { |i| purchase.add_item(params, i) }
    if save_purchase(purchase)
      redirect "/purchases/#{p.id}"
    else
      redirect "/purchases/#{p.id}/edit"
    end
  end

  get '/purchases/:id/delete' do              # delete a purchase
    redirect '/login' if !logged_in?
    purchase = current_user.purchases.find_by(id: params[:id])
    purchase.destroy if !purchase.nil?
    redirect '/purchases' if !purchase.nil?
  end

  get '/purchases/:id' do                   # show a single purchase
    redirect '/login' if !logged_in?
    @user = current_user
    @purchases = [@user.purchases.find_by(id: params[:id])]
    erb :'/purchases/index'
	end

  def save_purchase(p)
    if p.purchase_items.size > 0
      p.save
    else
      flash[:message] = "A purchase requires at least one item."
      false
    end
  end
end
