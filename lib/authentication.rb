module Sinatra
  module Authentication
    def self.registered(app)

      get '/login' do
        erb :login
      end

      post '/login' do
        if user = User.authenticate(params[:email], params[:password])
          session[:user] = user.id
          flash[:notice] = "Welcome back #{user.email}"
          redirect '/lists'
        else
          flash[:error] = 'Invalid email address or password'
          redirect '/login'
        end
      end

      get '/logout' do
        session[:user] = nil
        flash[:notice] = 'Logged out successfully.'
        redirect '/login'
      end

      get '/signup' do
        @list = List.new
        erb :signup
      end

      post '/signup' do
        @user = User.new(params[:user])
        if @user.save
          @user.reload
          @user.lists.create(params[:list])
          session[:user] = @user.id
          flash[:notice] = "Welcome to NamingTogether! This is your first list!"
          redirect "/list/#{@user.lists.first.url}"
        else
          flash[:error] = 'Oops, we were unable to create your account, please try again.'
          redirect '/signup'
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
          flash[:notice] = "Settings updated."
          redirect "/"
        else
          flash[:error] = "Oops, we unable to save your settings, please try again."
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
