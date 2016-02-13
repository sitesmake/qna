class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :body, presence: true
  validates :question_id, numericality: true, presence: true
  validates :user_id, numericality: true, presence: true

  default_scope { order('best DESC, updated_at') }

  def make_best
  	Answer.where(question: self.question, best: true).update_all(best: false)
  	self.update_attributes(best: true)
  end
end
