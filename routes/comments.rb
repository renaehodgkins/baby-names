get '/lists/:list_id/:id/comments' do
  @list = List.get(params[:list_id])
  @name = @list.names.get(params[:id])
  @comments = @name.comments.all(:list_id => @list.id)
  erb :comments
end

post '/lists/:list_id/names/:id/comments' do
  @list = List.get(params[:list_id])
  @name = Name.get(params[:id])
  @comment = @name.comments.new(:body => params[:comment_body],
                                :author => params[:comment_author] || 'anonymous',
                                :list_id => @list.id)
  if @comment.save
    flash[:notice] = "Comment saved."
  else
    flash[:error] = "Oops, we were unable to save your comment."
  end

  redirect "/lists/#{@list.to_param}/#{@name.to_param}/comments"
end

delete '/lists/:list_id/:name_id/comments/:id' do
  login_required
  @list = current_user.lists.get(params[:list_id])
  @name = @list.names.get(params[:name_id])
  puts @name.inspect
  @comment = @name.comments.get(params[:id])
  @comment.destroy
  flash[:notice] = "Comment removed."
  redirect "/lists/#{@list.to_param}/#{@name.to_param}/comments"
end
