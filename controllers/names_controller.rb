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
