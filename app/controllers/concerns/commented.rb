module Commented
  extend ActiveSupport::Concern

  included do
    before_action :load_resource, only: :comment
  end

  def comment
    @comment = @commentable.comments.build(user: current_user, body: params[:comment][:body])

    respond_to do |format|
      if @comment.save
        format.js do
          PrivatePub.publish_to "/#{controller_name.classify}/#{@commentable.id}/comments", comment: @comment.to_json
        end
      else
        format.js
      end
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def load_resource
    @commentable = model_klass.find(params[:id])
  end
end
