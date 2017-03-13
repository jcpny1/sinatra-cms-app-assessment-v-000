class UserController < ApplicationController

  get '/login' do
    redirect '/purchases' if logged_in?
    erb :'/users/login'
	end

	get '/logout' do
		session.clear
		redirect '/'
	end

  get '/users/new' do
    redirect '/purchases' if logged_in?
    erb :'/users/new'
	end

  post '/login' do
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/purchases'
    else
      flash[:message] = "Username and/or password are incorrect."
      redirect '/login'
    end
  end

	post '/users'  do
    user = User.new(params)
    if user.save
      session[:user_id] = user.id
      redirect '/purchases'
    else
      flash[:message] = user.errors.full_messages
      redirect '/users/new'
    end
	end
end
