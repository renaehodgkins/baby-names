get '/names/new' do
  erb :new
end

# create
post '/lists/:url/names' do
  puts params.inspect
  @list = List.all(:url => params[:url]).first
  @name = @list.names.new(:name => params[:name_name], :gender => params[:gender_gender])
  if @name.save
    redirect "/lists/#{@list.url}"
  else
    @message = 'The name was not saved - please speficy a name AND a gender'
    redirect "/lists/#{@list.url}"
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
