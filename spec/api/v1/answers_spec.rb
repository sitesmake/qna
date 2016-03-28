require 'rails_helper'

describe "Answers API" do
  let(:access_token) { create :access_token }
  let!(:question) { create :question }

  describe "GET /index" do
    context "unauthorized" do
      it "returns 401 status if there is no access token" do
        get "/api/v1/questions/#{question.id}/answers", format: :json
        expect(response.status).to eq 401
      end

      it "returns 401 status if access token is invalid" do
        get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context "authorized" do
      let!(:answers) { create_list(:answer, 2, question: question) }
      let!(:other_answer) { create :answer }

      before do
        get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token
      end

      it "returns 200 status code" do
        expect(response).to be_success
      end

      it "returns list of answers" do
        expect(response.body).to have_json_size(2).at_path("answers")
      end

      %w(id question_id body created_at updated_at user_id best).each do |attr|
        it "answer object contains #{attr}" do
          answer = answers.first
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end
  end
end
