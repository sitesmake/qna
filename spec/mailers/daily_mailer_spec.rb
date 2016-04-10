require "rails_helper"

RSpec.describe DailyMailer, type: :mailer do
  describe "digest" do
    let!(:user) { create(:user) }
    let!(:questions) { create_list(:question, 3, user: user) }
    let!(:question_not_send) { create(:question, user: user, created_at: Time.current.last_week) }
    let(:mail) { DailyMailer.digest(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Вопросы за прошедший день")
      expect(mail.to).to eq([user.email])
    end

    shared_examples_for "body rendering" do |body|
      it "renders the #{body.to_s}" do
        questions.each do |question|
          expect(mail.send(body).body.encoded).to include(question.title)
          expect(mail.send(body).body.encoded).to include(question_url(question.id))
        end

        expect(mail.send(body).body.encoded).to_not include(question_not_send.title)
        expect(mail.send(body).body.encoded).to_not include(question_url(question_not_send.id))
      end
    end

    it_behaves_like "body rendering", :text_part
    it_behaves_like "body rendering", :html_part
  end

  describe "notify" do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question) }

    let(:mail) { DailyMailer.notify(user, question, answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("Новый ответ на вопрос: #{question.title}")
      expect(mail.to).to eq([user.email])
    end

    it "renders answer in email body html" do
        expect(mail.send(:text_part).body.encoded).to include(answer.body)
    end

    it "renders answer in email body text" do
        expect(mail.send(:html_part).body.encoded).to include(answer.body)
    end
  end

end
