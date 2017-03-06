class PurchaseController < ApplicationController

  # get '/tweets/new' do
  #   if logged_in?
  #     erb :'/tweets/create_tweet'
  #   else
	#     redirect '/login'
  #   end
	# end
  #
  # get '/tweets/:id/delete' do
  #   if logged_in?
  #     tweet = Tweet.find(params[:id])
  #     tweet.delete
  #   else
	#     redirect '/login'
  #   end
	# end
  #
  # get '/tweets/:id/edit' do
  #   if logged_in?
  #     @tweet = Tweet.find(params[:id])
  #     erb :'/tweets/edit_tweet'
  #   else
	#     redirect '/login'
  #   end
	# end
  #
  # get '/tweets/:id' do
  #   if logged_in?
  #     @tweet = Tweet.find(params[:id])
  #     erb :'/tweets/show_tweet'
  #   else
	#     redirect '/login'
  #   end
	# end
  #
  get '/purchase/:id' do
    redirect '/login' if !logged_in?
    @user = User.find(session[:user_id])
    @purchases = []
    @purchases << Purchase.find(params[:id])
    erb :'/purchases/purchases'
	end

  get '/purchase' do
    redirect '/login' if !logged_in?
    user_id = session[:user_id]
    @user = User.find(user_id)
    erb :'/purchases/new'
	end

  get '/purchases' do
    redirect '/login' if !logged_in?
    user_id = session[:user_id]
    @user = User.find(user_id)
    @purchases = Purchase.where(user_id: user_id)
    erb :'/purchases/purchases'
	end
  #
  # post '/tweets/:id/delete' do
  #   if logged_in?
  #     tweet = Tweet.find(params[:id])
  #     if tweet.user_id == session[:user_id]
  #       tweet.delete
  #     end
  #     redirect '/tweets'
  #   else
	#     redirect '/login'
  #   end
	# end
  #
  # post '/tweets/:id' do
  #   tweet = Tweet.find(params[:id])
  #   if tweet.update(content: params[:content])
  #     redirect "/tweets/#{tweet.id}"
  #   else
  #     redirect "/tweets/#{tweet.id}/edit"
  #   end
  # end
  #
  post '/purchase' do
    puts params
    redirect '/login' if !logged_in?
    purchase = Purchase.new(user_id: session[:user_id])
    purchase_item = PurchaseItem.new(purchase_id: purchase.id, item: Item.find(params[:select_item]), sale_price: params[:price], quantity: params[:quantity])
    purchase.purchase_items << purchase_item
    purchase.save
    redirect "/purchase/#{purchase.id}"
  end

end
