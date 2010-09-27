get '/all_lists' do
  @lists = List.all
  erb :all_lists
end

get '/lists' do
  @lists = current_user.lists.all
  erb :lists
end

get '/list/:id' do
  @list = List.get(params[:id])
  @female_names = @list.female_names
  @male_names   = @list.male_names
  erb :list
end

get '/lists/new' do
  login_required
  @list = current_user.lists.new
  erb :list_new
end

get '/lists/:id/edit' do
  login_required
  @list = current_user.lists.get(params[:id].to_i)
  erb :list_edit
end

put '/list/:id' do
  @list = current_user.lists.get(params[:id].to_i)
  if @list.update_attributes(params[:list])
    flash[:notice] = "List '#{@list.url}' updated successfully."
    redirect "/list/#{@list.to_param}"
  else
    flash[:error] = "Oops, we were unable to update your list"
    erb :list_edit
  end
end

post '/lists' do
  login_required
  @list = current_user.lists.new(params[:list])
  if @list.save
    flash[:notice] = "List '#{@list.url}' has been created."
    redirect "/list/#{@list.to_param}"
  else
    flash[:error] = "Oops, we were unable to create your list"
    erb :list_new
  end
end

delete '/list/:id' do
  login_required
  @list = current_user.lists.get(params[:id].to_i)
  @list.destroy
  flash[:notice] = "List has been deleted."
  redirect "/lists"
end
