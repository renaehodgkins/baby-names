get '/all_names' do
  @names = RootName.all
  erb :all_names
end

get '/names/new' do
  erb :new
end

# create
post '/lists/:id/names' do
  @list = List.get(params[:id])
  @name = @list.names.new(:name => params[:name_name], :gender => params[:gender_gender])
  if @name.save
    flash[:notice] = "#{@name.name} has been added to the list."
    redirect "/list/#{@list.to_param}"
  else
    flash[:error] = 'Oops, we were unable to save your name.'
    redirect "/list/#{@list.to_param}"
  end
end 

# show
get '/names/:id' do
  @name = RootName.get(params[:id])
  if @name
    erb :show
  else
    redirect '/names'
  end
end

# destroy
delete '/lists/:list_id/names/:id' do 
  login_required
  @list = List.get(params[:list_id])
  @name = @list.names.get(params[:id])
  @name.destroy
  flash[:notice] = "The name has been removed from your list."
  redirect "/list/#{@list.to_param}"
end
