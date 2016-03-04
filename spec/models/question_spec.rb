require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many :attachments }

  it { should belong_to(:user) }
  it { should validate_presence_of :user_id }

  it { should accept_nested_attributes_for :attachments }

  it { should have_many :votes }

  context "votes" do
    let!(:question) { create(:question) }

    it "can view rating" do
      question.votes.create(voice: 1)
      expect(question.rating).to eq(1)
    end

    it "can vote up" do
      user = create(:user)
      question.vote_up(user)
      expect(question.rating).to eq(1)
    end

    it "can vote down" do
      user = create(:user)
      question.vote_down(user)
      expect(question.rating).to eq(-1)
    end
  end

end
