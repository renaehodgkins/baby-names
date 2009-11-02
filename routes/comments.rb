get '/lists/:url/names/:id/comments' do
  @list = List.all(:url => params[:url]).first
  @name = Name.all(:id => params[:id]).first
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
    @message = "Commnet saved"
  else
    @message = "Unable to save comment"
  end

  redirect "/lists/#{@list.url}/names/#{@name.id}/comments"
end
