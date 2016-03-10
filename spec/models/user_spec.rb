require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { should have_many(:questions) }

  it { should have_many(:answers) }

  context "vote for" do
    let!(:question) { create(:question) }

    it "works" do
      user = create(:user)
      expect(user.voted_for?(question)).to be false
      question.vote_up(user)
      expect(user.voted_for?(question)).to be true
    end
  end
end
