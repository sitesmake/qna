class User < ActiveRecord::Base
  has_many :questions
  has_many :answers
  has_many :votes
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def author_of?(model)
    id == model.user_id
  end

  def voted_for?(model)
    #model.votes.collect(&:user_id).include?(self.id)
    votes.where(votable: model).exists?
  end

  def vote_up(model)
    model.votes.create(voice: 1, user: self)
  end

  def vote_down(model)
    model.votes.create(voice: -1, user: self)
  end
end
