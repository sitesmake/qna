require 'rails_helper'

shared_examples_for "votable" do
  let(:model) { described_class }

  it { should have_many(:votes).dependent(:destroy) }

  context "votes methods" do
    let!(:user) { create(:user) }
    let!(:object) { create(model.to_s.underscore.to_sym) }

    it "can view rating" do
      object.votes.create(voice: 1, user: user)
      expect(object.rating).to eq(1)
    end

    it "can vote up" do
     object.vote_up(user)
     expect(object.rating).to eq(1)
    end

    it "can vote down" do
     object.vote_down(user)
     expect(object.rating).to eq(-1)
    end
  end

end
