class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :body, presence: true
  validates :user_id, numericality: true, presence: true
end
