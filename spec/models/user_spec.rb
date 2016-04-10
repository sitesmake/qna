require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:votes) }
  it { should have_many(:authorizations) }
  it { should have_many(:subscriptions) }

  context "subscriptions" do
    let!(:user) { create(:user) }
    let!(:question) { create(:question) }

    describe "#create_subscription" do
      it "creates subscription for user" do
        expect { User.create_subscription(question).to change(Subscription, :count).by(1) }
      end
    end

    describe "#destroy_subscription" do
      it "destroys subscription" do
        expect { User.destroy_subscription(question.subscriptions.first).to change(Subscription, :count).by(-1) }
      end
    end
  end

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

  describe ".find_for_oauth" do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    context "user already has authorization" do
      it "returns the user" do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context "user has no authorization" do
      context "user already exists" do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email } ) }
        it "does not create new user" do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it "creates authorization for user" do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it "creates authorization with provider and uid" do
          user = User.find_for_oauth(auth)
          authorization = user.authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it "returns the user" do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context "user does not exist" do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@user.com' } ) }

        it "creates new user" do
          expect { User.find_for_oauth(auth).to change(User, :count).by(1) }
        end

        it "returns new user" do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it "fills user email" do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info.email
        end

        it "creates authorization for user" do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it "creates authorization with provider and uid" do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

      end

      context "no email returned by oauth" do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '123456') }

        it "creates user email" do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq "vkontakte_123456@qna.dev"
        end
      end
    end
  end
end
