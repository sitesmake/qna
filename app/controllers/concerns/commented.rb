module Commented
  extend ActiveSupport::Concern

  included do
    before_action :load_commented_resource, only: :comment
    before_action :load_comment, only: :destroy_comment
    before_action :check_comment_author, only: :destroy_comment
  end

  def comment
    @comment = @commentable.comments.build(user: current_user, body: params[:comment][:body])

    question_id = @commentable.id if controller_name=="questions"
    question_id = @commentable.question.id if controller_name=="answers"

    respond_to do |format|
      if @comment.save
        format.js do
          PrivatePub.publish_to "/questions/#{question_id}/comments/#{controller_name}", comment: @comment.to_json
        end
      else
        format.js
      end
    end
  end

  def destroy_comment
    @comment.destroy if current_user.author_of?(@comment)
    render "comments/destroy", format: :js
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def load_commented_resource
    @commentable = model_klass.find(params[:id])
  end

  def load_comment
    @comment = Comment.find(params[:comment_id])
  end

  def check_comment_author
    unless current_user.author_of?(@comment)
      head(:forbidden)
    end
  end
end