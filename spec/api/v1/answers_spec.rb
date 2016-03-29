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

  describe "GET /show" do
    let!(:answer) { create(:answer, question: question) }

    context "unauthorized" do
      it "returns 401 status if there is no access token" do
        get "/api/v1/answers/#{answer.id}", format: :json
        expect(response.status).to eq 401
      end

      it "returns 401 status if access token is invalid" do
        get "/api/v1/answers/#{answer.id}", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context "authorized" do
      let!(:comments) { create_list(:comment, 2, commentable: answer) }
      let!(:attachments) { create_list(:attachment, 2, attachable: answer) }

      before do
        get "/api/v1/answers/#{answer.id}", format: :json, access_token: access_token.token
      end

      it "returns 200 status code" do
        expect(response).to be_success
      end

      %w(id question_id body created_at updated_at user_id best).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      context "comments" do
        it "returns list of comments" do
          expect(response.body).to have_json_size(2).at_path("answer/comments")
        end

        %w(id user_id commentable_id commentable_type body created_at updated_at).each do |attr|
          it "comment object contains #{attr}" do
            comment = comments.first
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}")
          end
        end
      end

      context "attachments" do
        it "returns list of attached files" do
          expect(response.body).to have_json_size(2).at_path("answer/attachments")
        end

        it "attachments object contains file" do
          attachment = attachments.first
          expect(response.body).to be_json_eql(attachment.send(:file).to_json).at_path("answer/attachments/0/file")
        end
      end
    end
  end

  describe "/POST create" do
    context "unauthorized" do
      it "returns 401 status if there is no access token" do
        post "/api/v1/questions/#{question.id}/answers", format: :json
        expect(response.status).to eq 401
      end

      it "returns 401 status if access token is invalid" do
        post "/api/v1/questions/#{question.id}/answers", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context "authorized" do
      let!(:user) { create :user}
      let!(:access_token) { create(:access_token, resource_owner_id: user.id)}

      context "with valid attributes" do
        it "returns 200 status" do
          post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:answer), format: :json, access_token: access_token.token
          expect(response).to be_success
        end

        it "saves the answer" do
          expect { post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:answer), format: :json, access_token: access_token.token }.to change(user.answers, :count).by(1)
        end
      end

      context "with invalid attributes" do
        it "returns 422 status" do
          post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:invalid_answer), format: :json, access_token: access_token.token
          expect(response.status).to eq 422
        end

        it "don't saves the answer" do
          expect { post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:invalid_answer), format: :json, access_token: access_token.token }.to_not change(user.answers, :count)
        end
      end
    end
  end
end
