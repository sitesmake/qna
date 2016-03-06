require 'rails_helper'

shared_examples_for "votable" do
  let(:model) { described_class }

  it { should have_many :votes }

  context "votes methods" do
    let!(:objekt) { create(model.to_s.underscore.to_sym) }

    it "can view rating" do
      objekt.votes.create(voice: 1)
      expect(objekt.rating).to eq(1)
    end

    it "can vote up" do
      user = create(:user)
      objekt.vote_up(user)
      expect(objekt.rating).to eq(1)
    end

    it "can vote down" do
      user = create(:user)
      objekt.vote_down(user)
      expect(objekt.rating).to eq(-1)
    end
  end

end
