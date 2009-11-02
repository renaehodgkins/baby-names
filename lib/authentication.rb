module Sinatra
  module Authentication
    def self.registered(app)

      get '/login' do
        erb :login
      end

      post '/login' do
        if user = User.authenticate(params[:email], params[:password])
          session[:user] = user.id
          redirect '/'
        else
          redirect '/login'
        end
      end

      get '/logout' do
        session[:user] = nil
        redirect '/login'
      end

      get '/signup' do
        erb :signup
      end

      post '/signup' do
        @user = User.new(params[:user])
        if @user.save
          session[:user] = @user.id
          redirect "/lists/#{@user.lists.first.url}"
        else
          redirect '/'
        end
      end

      get '/settings' do
        login_required
        @user = User.first(:id => current_user.id)
        erb :settings
      end

      post '/settings' do
        login_required

        if params[:user][:password] == ""
          params[:user].delete("password")
          params[:user].delete("password_confirmation")
        end

        user = User.first(:id => current_user.id)
        if user.update_attributes(params[:user])
          redirect "/"
        else
          erb :settings
        end
      end
    end
  end

  module Helpers
    def login_required
      return if session[:user]
      redirect '/login'
    end

    def current_user
      User.first(:id => session[:user]) if session[:user]
    end

    def logged_in?
      !!session[:user]
    end
  end

  register Authentication
end
