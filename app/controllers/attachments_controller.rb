class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment
  before_action :check_attachment_author

  def destroy
  	@attachment.destroy if current_user.author_of?(@attachment.attachable)
  	respond_to :js
  end

  private

  def load_attachment
    @attachment = Attachment.find(params[:id])
  end

  def check_attachment_author
    unless current_user.author_of?(@attachment.attachable)
      head(:forbidden)
    end
  end
end
