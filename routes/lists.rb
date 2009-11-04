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
  puts params.inspect
  @list = List.all(:url => params[:url]).first
  redirect "/lists/#{@list.url}" unless current_user.lists.include?(@list)
  @list.update_attributes(:url => params[:list_url])
  redirect "/lists/#{@list.url}"
end
