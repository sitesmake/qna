module Voted
  extend ActiveSupport::Concern

  included do
    before_action :load_resource, only: [:vote, :cancel_vote]
    before_action :check_voted, only: [:vote]
    before_action :check_author, only: [:vote]
  end

  def vote
    if params[:points].to_i < 0
      @vote = @votable.vote_down(current_user)
      @message = "voted down"
    else
      @vote = @votable.vote_up(current_user)
      @message = "voted up"
    end

    render json: { id: @votable.id, message: @message, output: render_to_string(partial: 'votes/block', locals: { data: @votable }) }
  end

  def cancel_vote
    @vote = @votable.votes.where(user: current_user).first
    @vote.destroy
    @message = "vote is cancelled"

    render json: { id: @votable.id, message: @message, output: render_to_string(partial: 'votes/block', locals: { data: @votable }) }
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def load_resource
    @votable = model_klass.find(params[:id])
  end

  def check_author
    if current_user.author_of?(@votable)
      head(:forbidden)
    end
  end

  def check_voted
    if current_user.voted_for?(@votable)
      head(:forbidden)
    end
  end
end
