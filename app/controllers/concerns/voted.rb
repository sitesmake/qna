module Voted
  extend ActiveSupport::Concern

  included do
    before_action :load_voted_resource, only: [:vote_up, :vote_down, :cancel_vote]
    before_action :check_voted, only: [:vote_up, :vote_down]
  end

  def vote_up
    authorize! :vote, @votable

    @vote = @votable.vote_up(current_user)
    @message = "voted up"

    render json: { id: @votable.id, message: @message, output: render_to_string(partial: 'votes/block', locals: { data: @votable }) }
  end

  def vote_down
    authorize! :vote, @votable

    @vote = @votable.vote_down(current_user)
    @message = "voted down"

    render json: { id: @votable.id, message: @message, output: render_to_string(partial: 'votes/block', locals: { data: @votable }) }
  end

  def cancel_vote
    @vote = current_user.vote_for(@votable)

    authorize! :destroy, @vote

    @vote.destroy
    @message = "vote is cancelled"

    render json: { id: @votable.id, message: @message, output: render_to_string(partial: 'votes/block', locals: { data: @votable }) }
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def load_voted_resource
    @votable = model_klass.find(params[:id])
  end

  def check_voted
    if current_user.voted_for?(@votable)
      head(:forbidden)
    end
  end
end
