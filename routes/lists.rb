get '/lists' do
  @lists = current_user.lists.all
  erb :lists
end

get '/lists/:url' do
  @list = List.all(:url => params[:url]).first
  @female_names = @list.female_names
  @male_names   = @list.male_names
  erb :list
end

put '/list/:url' do
  @list = current_user.lists.all(:url => params[:url]).first
  if @list.update_attributes(:url => params[:list_url])
    flash[:notice] = "List '#{@list.url}' updated successfully."
  else
    @list.reload
    flash[:error] = "Oops, we were unable to update your list"
  end
  redirect "/lists/#{@list.url}"
end

post '/ ' do
  login_required
  @list = current_user.lists.new(:url => params[:list_url])
  if @list.save
    flash[:notice] = "List #{@list.url} has been created."
    redirect "/lists/#{@list.url}"
  else
    flash[:error] = "Oops, we were unable to create your list"
    erb "/lists"
  end
end

delete '/lists/:url' do
  login_required
  @list = current_user.lists.all(:url => params[:url]).first
  @list.destroy
  flash[:notice] = "List has been deleted."
  redirect "/lists"
end
