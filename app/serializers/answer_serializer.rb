class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :question_id, :body, :created_at, :updated_at, :user_id, :best
  has_many :comments
  has_many :attachments
end
