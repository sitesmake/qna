class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_comment
  before_action :check_comment_author

  def destroy
  	@comment.destroy if current_user.author_of?(@comment)
  	respond_to :js
  end

  private

  def load_comment
    @comment = Comment.find(params[:id])
  end

  def check_comment_author
    unless current_user.author_of?(@comment)
      head(:forbidden)
    end
  end
end
