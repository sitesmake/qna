class Question < ActiveRecord::Base
  include Votable
  include Commentable

	has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable
  belongs_to :user

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true
  validates :user_id, numericality: true, presence: true

  scope :for_last_day, -> { where("created_at >= ?", 1.day.ago) }

end
