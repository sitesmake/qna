class Question < ActiveRecord::Base
	has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable
  has_many :votes, as: :votable
  belongs_to :user

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true
  validates :user_id, numericality: true, presence: true

  def rating
    self.votes.sum(:voice)
  end

  def vote_up(user)
    self.votes.create(voice: 1, user: user)
  end

  def vote_down(user)
    self.votes.create(voice: -1, user: user)
  end
end
