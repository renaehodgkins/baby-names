require 'rubygems'
require 'sinatra'
require 'sass'
require 'lib/partials'
require 'dm-core'
require 'dm-timestamps'
require 'dm-validations'
require 'sinatra-authentication'

Dir["#{File.dirname(__FILE__)}/models/*.rb"].each {|f| require f}

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/names.sqlite3")
DataMapper.auto_upgrade!

helpers do
  include Sinatra::Partials
  
  def voted_for?(name)
    return false unless name.votes.size > 0
    name.votes.first(:ip => @env['REMOTE_ADDR']) ? true : false
  end

  def clearfix
    "<div class='clearfix'></div>"
  end
end

get '/stylesheet.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :stylesheet
end

get '/reset.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :reset
end

get '/' do 
  @female_names = Name.female
  @male_names = Name.male
  erb :index
end

get '/new' do
  erb :new
end

# create
post '/' do
  puts params.inspect
  @name = Name.new(:name => params[:name_name], :gender => params[:gender_gender])
  if @name.save
    redirect '/'
  else
    @message = 'The name was not saved - please speficy a name AND a gender'
    erb :new
  end
end 

# show
get '/:id' do
  @name = Name.get(params[:id])
  if @name
    erb :show
  else
    redirect '/'
  end
end

# destroy
delete '/:id' do 
  login_required
  @name = Name.get(params[:id])
  if @name && current_user.admin?
    @name.destroy
    redirect '/'
  else
    redirect '/'
  end
end

# create vote
post '/:id/vote/:rank' do
  @name = Name.get(params[:id])
  @vote = @name.votes.new(:vote => params[:rank], :ip => @env['REMOTE_ADDR']) 
  if @vote.save
    @message = "Vote Success"
  else
    @message = "Vote Failed"
  end
  redirect '/'   
end

get '/:id/comments' do
  @name = Name.get(params[:id])
  erb :comments
end


# create comment
post '/:id/comments' do
  @name = Name.get(params[:id])
  @comment = @name.comments.new(:body => params[:comment_body])
  if @comment.save
    @message = "Commnet saved"
  else
    @message = "Unable to save comment"
  end
  redirect "/#{@name.id}/comments"
end

