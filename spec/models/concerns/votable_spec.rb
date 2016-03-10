require 'rails_helper'

shared_examples_for "votable" do
  let(:model) { described_class }

  it { should have_many :votes }

  context "votes methods" do
    let!(:object) { create(model.to_s.underscore.to_sym) }

    it "can view rating" do
      object.votes.create(voice: 1)
      expect(object.rating).to eq(1)
    end

    #it "can vote up" do
    #  user = create(:user)
    #  object.vote_up(user)
    #  expect(object.rating).to eq(1)
    #end

    #it "can vote down" do
    #  user = create(:user)
    #  object.vote_down(user)
    #  expect(object.rating).to eq(-1)
    #end
  end

end
