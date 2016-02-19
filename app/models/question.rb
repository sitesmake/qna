class Question < ActiveRecord::Base
	has_many :answers, dependent: :destroy
  has_many :attachments
  belongs_to :user

  accepts_nested_attributes_for :attachments

  validates :title, :body, presence: true
  validates :user_id, numericality: true, presence: true
end
