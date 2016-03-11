class Answer < ActiveRecord::Base
  include Votable

  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true
  validates :question_id, numericality: true, presence: true
  validates :user_id, numericality: true, presence: true

  default_scope { order('best DESC, created_at') }

  def make_best
    ActiveRecord::Base.transaction do
      Answer.where(question: self.question, best: true).update_all(best: false)
      self.update_attributes(best: true)
    end
  end
end
