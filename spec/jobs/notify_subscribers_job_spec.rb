require 'rails_helper'

RSpec.describe NotifySubscribersJob, type: :job do
  let!(:users) { create_list(:user, 2) }
  let!(:question) { create(:question, user: users.first) }
  let!(:answer) { create(:answer, question: question, user: users.second) }

  before(:each) { users.second.toggle_subscription(question) }

  it "sends notifications" do
    users.each do |user|
      expect(DailyMailer).to receive(:notify).with(user, question, answer).and_call_original
    end

   NotifySubscribersJob.perform_now(question, answer)
  end
end
