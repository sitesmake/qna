class User < ActiveRecord::Base
  has_many :questions
  has_many :answers
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def author_of?(model)
    id == model.user_id
  end

  def voted_for?(model)
    model.votes.include?(user: self)
  end
end
