require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should have_many(:answers).dependent(:destroy) }

  it { should belong_to(:user) }
  it { should validate_presence_of :user_id }

  it { should have_many :attachments }
  it { should accept_nested_attributes_for :attachments }

  it_behaves_like "votable"
  it_behaves_like "commentable"

  it "subscribe author after create" do
    user = create(:user)
    question = create(:question, user: user)
    expect(question.subscriptions.first.user).to eq user
  end

end
