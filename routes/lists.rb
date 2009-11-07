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
    flash[:error]  = "List names must be at least 4 characters long and can include letters, numbers, dashes, and underscores."
  end
  redirect "/lists/#{@list.url}"
end

post '/ ' do
  login_required
  @list = current_user.lists.new(:url => params[:list_url])
  if @list.save
    redirect "/lists/#{@list.url}"
  else
    erb "/lists"
  end
end

delete '/lists/:url' do
  login_required
  @list = current_user.lists.all(:url => params[:url]).first
  @list.destroy
  redirect "/lists"
end
