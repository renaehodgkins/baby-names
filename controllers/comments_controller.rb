get '/:id/comments' do
  @name = Name.get(params[:id])
  erb :comments
end


# create comment
post '/:id/comments' do
  @name = Name.get(params[:id])
  @comment = @name.comments.new(:body => params[:comment_body],
                                :author => params[:comment_author] || 'anonymous')
  if @comment.save
    @message = "Commnet saved"
  else
    @message = "Unable to save comment"
  end
  redirect "/#{@name.id}/comments"
end