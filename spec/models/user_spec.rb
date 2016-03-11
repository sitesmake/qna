require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { should have_many(:questions) }

  it { should have_many(:answers) }

  context "vote for" do
    let!(:question) { create(:question) }
    let!(:user) { create(:user) }

    describe "#voted_for?" do
      it "returns false" do
        expect(user.voted_for?(question)).to be false
      end

      it "returns true" do
        create(:vote, votable: question, user: user, voice: 1)
        expect(user.voted_for?(question)).to be true
      end
    end

    describe "#vote_for" do
      it "returns correct vote" do
        vote = create(:vote, votable: question, user: user, voice: 1)
        expect(user.vote_for(question)).to eq(vote)
      end

      it "false if no vote" do
        expect(user.vote_for(question)).to_not be true
      end
    end
  end
end
