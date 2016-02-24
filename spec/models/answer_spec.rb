require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }

  it { should belong_to(:question) }
  it { should validate_presence_of :question_id }

  it { should belong_to(:user) }
  it { should validate_presence_of :user_id }

  it { should have_many :attachments }

  it { should accept_nested_attributes_for :attachments }

  context "best answer" do
    let!(:question) { create(:question) }

    it "sets best answer" do
      answer = create(:answer)
      expect(answer).to_not be_best

      answer.make_best
      expect(answer).to be_best
    end

    it "sets only one best answer" do
      answer1, answer2, answer3 = create_list(:answer, 3, question: question)

      answer1.make_best
      answer2.make_best

      [answer1, answer2, answer3].each { |a| a.reload }

      expect(answer1).to_not be_best
      expect(answer2).to be_best
      expect(answer3).to_not be_best
    end
  end
end
