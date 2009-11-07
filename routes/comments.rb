get '/lists/:url/:name' do
  @list = List.all(:url => params[:url]).first
  @name = @list.names.all(:name.like => params[:name]).first
  @comments = @name.comments.all(:list_id => @list.id)
  erb :comments
end


# create comment
post '/lists/:url/names/:id/comments' do
  @list = List.all(:url => params[:url]).first
  @name = Name.get(params[:id])
  @comment = @name.comments.new(:body => params[:comment_body],
                                :author => params[:comment_author] || 'anonymous',
                                :list_id => @list.id)
  if @comment.save
    flash[:notice] = "Commentent saved."
  else
    flash[:error] = "Oops, we were unable to save your comment."
  end

  redirect "/lists/#{@list.url}/#{@name.name}"
end
