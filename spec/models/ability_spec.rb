require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question}
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, user: user) }
    let(:comment) { create(:comment, user: user) }
    let(:other_user) { create :user }
    let(:other_question) { create :question}
    let(:other_answer) { create :answer }
    let(:other_comment) { create :comment }
    let(:other_question_answer) { create(:answer, question: other_question) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, question }
    it { should be_able_to :update, answer }
    it { should be_able_to :update, comment }

    it { should_not be_able_to :update, other_question }
    it { should_not be_able_to :update, other_answer }
    it { should_not be_able_to :update, other_comment }

    it { should be_able_to :destroy, question }
    it { should be_able_to :destroy, answer }
    it { should be_able_to :destroy, comment }

    it { should_not be_able_to :destroy, other_question }
    it { should_not be_able_to :destroy, other_answer }
    it { should_not be_able_to :destroy, other_comment }

    it { should be_able_to :vote, other_question }
    it { should be_able_to :vote, other_answer }

    it { should_not be_able_to :vote, question }
    it { should_not be_able_to :vote, answer }

    it { should be_able_to :set_best, Answer, question: { user: user } }
    it { should_not be_able_to :set_best, other_question_answer, question: { user: user } }

    it { should be_able_to :destroy, create(:attachment, attachable_id: question.id, attachable_type: 'Question') }
    it { should_not be_able_to :destroy, create(:attachment, attachable_id: other_question.id, attachable_type: 'Question') }
  end
end
