module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def rating
    votes.sum(:voice)
  end

  def vote_up(user)
   votes.create(voice: 1, user: user)
  end

  def vote_down(user)
   votes.create(voice: -1, user: user)
  end
end
