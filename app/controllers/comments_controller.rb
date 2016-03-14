class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: :create
  before_action :load_comment, only: :destroy
  before_action :check_comment_author, only: :destroy

  def create
    @comment = @commentable.comments.build(user: current_user, body: params[:comment][:body])

    question_id = @commentable.id if @resource_type == "questions"
    question_id = @commentable.question.id if @resource_type == "answers"

    respond_to do |format|
      if @comment.save
        format.js do
          PrivatePub.publish_to "/questions/#{question_id}/comments/#{@resource_type}", comment: @comment.to_json
        end
      else
        format.js
      end
    end
  end

  def destroy
    @comment.destroy if current_user.author_of?(@comment)
    render "comments/destroy", format: :js
  end

  private

  def set_commentable
    @resource_type = request.path.split('/').second
    @commentable = Question.find(params[:id]) if @resource_type == "questions"
    @commentable = Answer.find(params[:id]) if @resource_type == "answers"
  end

  def load_comment
    @comment = Comment.find(params[:id])
  end

  def check_comment_author
    unless current_user.author_of?(@comment)
      head(:forbidden)
    end
  end
end
