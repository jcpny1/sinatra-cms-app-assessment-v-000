class UserController < ApplicationController

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
		set :session_secret, "password_security"
  end

  get '/login' do
    if logged_in?
      redirect '/tweets'
    else
	    erb :'/users/login'
    end
	end

	get '/logout' do
		session.clear
		redirect '/login'
	end

  get '/signup' do
    if logged_in?
      redirect '/tweets'
    else
      erb :'/users/signup'
    end
	end

  get '/users/:slug' do
    user = User.find_by(name: params[:slug])
    @tweets = Tweet.find_by(user_id: user.id)
    erb :'/tweets/show'
  end

  post '/login' do
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/tweets'
    else
      redirect '/failure'
    end
  end

	post '/signup' do
    user = User.new(:username => params[:username], :email => params[:email], :password => params[:password])
    if user.save
      session[:user_id] = user.id
      redirect '/tweets'
    else
      redirect '/signup'
    end
	end

end
