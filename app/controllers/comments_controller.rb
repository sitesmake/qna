class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: :create
  before_action :load_comment, only: :destroy
  before_action :check_comment_author, only: :destroy
  before_action :create_comment, only: :create
  after_action :publish_comment, only: :create

  respond_to :js

  def create
    respond_with @comment
  end

  def destroy
    @comment.destroy if current_user.author_of?(@comment)
    respond_with(@comment)
  end

  private

  def publish_comment
    question_id = @commentable.id if @resource_type == "questions"
    question_id = @commentable.question.id if @resource_type == "answers"
    PrivatePub.publish_to "/questions/#{question_id}/comments/#{@resource_type}", comment: @comment.to_json if @comment.valid?
  end

  def create_comment
    @comment = @commentable.comments.create(user: current_user, body: params[:comment][:body])
  end

  def set_commentable
    @resource_type = request.path.split('/').second
    klass = @resource_type.singularize.capitalize.constantize
    @commentable = klass.find(params[:id])
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
