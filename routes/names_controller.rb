get '/names' do 
  @female_names = Name.female
  @male_names = Name.male
  erb :index
end

get '/names/new' do
  erb :new
end

# create
post '/names' do
  @name = Name.new(:name => params[:name_name], :gender => params[:gender_gender])
  if @name.save
    redirect '/names'
  else
    @message = 'The name was not saved - please speficy a name AND a gender'
    erb :new
  end
end 

# show
get '/names/:id' do
  @name = Name.get(params[:id])
  if @name
    erb :show
  else
    redirect '/names'
  end
end

# destroy
delete '/names/:id' do 
  login_required
  @name = Name.get(params[:id])
  if @name && current_user.admin?
    @name.destroy
    redirect '/names'
  else
    redirect '/names'
  end
end
