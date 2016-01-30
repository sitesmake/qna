class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :body, presence: true
  validates :question_id, numericality: true, presence: true
  validates :user_id, numericality: true, presence: true
end
