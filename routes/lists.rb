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
  @list = List.all(:url => params[:url]).first
  redirect "/lists/#{@list.url}" unless current_user.lists.include?(@list)
  @list.update_attributes(:url => params[:list_url])
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
