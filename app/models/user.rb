class User < ActiveRecord::Base
  has_many :questions
  has_many :answers
  has_many :votes
  has_many :authorizations
  has_many :subscriptions

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :vkontakte]

  def author_of?(model)
    id == model.user_id
  end

  def voted_for?(model)
    #model.votes.collect(&:user_id).include?(self.id)
    votes.where(votable: model).exists?
  end

  def vote_for(model)
    votes.where(votable: model).first
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email] rescue "#{auth.provider}_#{auth.uid}@qna.dev"

    user = User.where(email: email).first

    if user
      user.create_authorization(auth)
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.create_authorization(auth)
    end

    user
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def subscribed_for?(question)
    subscriptions.exists?(question_id: question)
  end

  # def toggle_subscription(question)
  #   if subscribed_for?(question)
  #     subscriptions.where(user: self, question: question).destroy_all
  #   else
  #     subscriptions.create(user: self, question: question)
  #   end
  # end

  def create_subscription(question)
    subscriptions.create(user: self, question: question)
  end

  def destroy_subscription(subsctiption)
    Subscription.find(subsctiption).destroy
  end
end
