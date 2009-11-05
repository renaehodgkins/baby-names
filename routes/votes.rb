# create vote
post '/:id/vote' do
  @name = Name.get(params[:id])
  @vote = @name.votes.all(:ip => @env['REMOTE_ADDR']).first
  if @vote
    @vote.vote = params[:rating]
  else
    @vote = @name.votes.new(:vote => params[:rating], :ip => @env['REMOTE_ADDR']) 
  end

  if @vote.save
    @message = "Vote Success"
  else
    @message = "Vote Failed"
  end

  if request.xhr? 
    @name.reload
    "<li class='current-rating' style='width:#{@name.percentage_vote}%'> #{@name.average_vote}/5 ratings.</li>"
  else
    redirect '/'   
  end
end
