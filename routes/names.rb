get '/names/new' do
  erb :new
end

# create
post '/lists/:url/names' do
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
get '/names/:name' do
  @name = RootName.all(:name => params[:name].capitalize).first
  if @name
    erb :show
  else
    redirect '/names'
  end
end

# destroy
delete '/lists/:url/names/:id' do 
  login_required
  @list = List.all(:url => params[:url]).first
  @name = @list.names.get(params[:id])
  @name.destroy
  redirect "/lists/#{@list.url}"
end
