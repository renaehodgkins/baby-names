get '/lists' do
  @lists = current_user.lists.all
  erb :lists
end

get '/list/:url' do
  @list = List.all(:url => params[:url]).first
  @female_names = @list.female_names
  @male_names   = @list.male_names
  erb :list
end

get '/lists/new' do
  login_required
  @list = current_user.lists.new
  erb :list_new
end

get '/lists/:url/edit' do
  login_required
  @list = current_user.lists.all(:url => params[:url]).first
  erb :list_edit
end

put '/list/:url' do
  puts params.inspect
  @list = current_user.lists.all(:url => params[:url]).first
  if @list.update_attributes(params[:list])
    flash[:notice] = "List '#{@list.url}' updated successfully."
  else
    @list.reload
    flash[:error] = "Oops, we were unable to update your list"
  end
  redirect "/list/#{@list.url}"
end

post '/lists' do
  login_required
  @list = current_user.lists.new(params[:list])
  if @list.save
    flash[:notice] = "List #{@list.url} has been created."
    redirect "/list/#{@list.url}"
  else
    flash[:error] = "Oops, we were unable to create your list"
    erb "/lists"
  end
end

delete '/list/:url' do
  login_required
  @list = current_user.lists.all(:url => params[:url]).first
  @list.destroy
  flash[:notice] = "List has been deleted."
  redirect "/lists"
end
