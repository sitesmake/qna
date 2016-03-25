class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment

  authorize_resource

  respond_to :js

  def destroy
  	@attachment.destroy if current_user.author_of?(@attachment.attachable)
    respond_with(@attachment)
  end

  private

  def load_attachment
    @attachment = Attachment.find(params[:id])
  end

end
