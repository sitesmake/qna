class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities
    guest_abilities

    can :create, [Question, Answer, Comment]

    can :update, [Question, Answer, Comment], user_id: user.id
    can :destroy, [Question, Answer, Comment, Vote], user_id: user.id

    can :vote, [Question, Answer] do |object|
      object.user_id != user.id
    end

    can :set_best, Answer, question: { user_id: user.id }

    can :destroy, Attachment, attachable: { user_id: user.id }

    can :me, User, { user_id: user.id }

    can :toggle_subscription, Question

  end

  def admin_abilities
    can :manage, :all
  end
end
