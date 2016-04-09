class Question < ActiveRecord::Base
  include Votable
  include Commentable

	has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable
  belongs_to :user
  has_many :subscriptions, dependent: :destroy

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true
  validates :user_id, numericality: true, presence: true

  scope :for_last_day, -> { where("created_at >= ?", 1.day.ago) }

  after_create :subscribe_author

  private

  def subscribe_author
    # user.toggle_subscription(self)
    user.create_subscription(self)
  end

end
