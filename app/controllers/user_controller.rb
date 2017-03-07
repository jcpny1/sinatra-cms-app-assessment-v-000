class UserController < ApplicationController

  get '/login' do
    redirect '/purchases' if logged_in?
    erb :'/users/login'
	end

	get '/logout' do
		session.clear
		redirect '/'
	end

  get '/signup' do
    redirect '/purchases' if logged_in?
    erb :'/users/signup'
	end

  post '/login' do
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/purchases'
    else
      redirect '/login'
    end
  end

	post '/signup'  do
    user = User.new(params)
    if user.save
      session[:user_id] = user.id
      redirect '/purchases'
    else
      redirect '/signup'
    end
	end
end
