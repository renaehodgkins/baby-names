get '/names/new' do
  erb :new
end

# create
post '/lists/:url/names' do
  @list = List.all(:url => params[:url]).first
  @name = @list.names.new(:name => params[:name_name], :gender => params[:gender_gender])
  if @name.save
    flash[:notice] = "#{@name.name} has been added to the list."
    redirect "/lists/#{@list.url}"
  else
    flash[:error] = 'Oops, we were unable to save your name.'
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
  flash[:notice] = "The name has been removed from your list."
  redirect "/lists/#{@list.url}"
end
