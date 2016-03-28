require 'rails_helper'

describe "Questions API" do
  let(:access_token) { create :access_token }

  describe "GET /index" do
    context "unauthorized" do
      it "returns 401 status if there is no access token" do
        get '/api/v1/questions', format: :json
        expect(response.status).to eq 401
      end

      it "returns 401 status if access token is invalid" do
        get '/api/v1/questions', format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context "authorized" do
      let!(:questions) { create_list(:question, 2) }
      let!(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before do
    		get '/api/v1/questions', format: :json, access_token: access_token.token
      end

    	it "returns 200 status code" do
    		expect(response).to be_success
    	end

      it "returns list of questions" do
        expect(response.body).to have_json_size(2).at_path("questions")
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          question = questions.first
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      it "question object contains short title" do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("questions/0/short_title")
      end

      context "answers" do
        it "included in question object" do
          expect(response.body).to have_json_size(1).at_path("questions/0/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "question object contains #{attr}" do
            question = questions.first
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end

    end
  end

  describe "GET /show" do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }

    context "unauthorized" do
      it "returns 401 status if there is no access token" do
        get "/api/v1/questions/#{question.id}", format: :json
        expect(response.status).to eq 401
      end

      it "returns 401 status if access token is invalid" do
        get "/api/v1/questions/#{question.id}", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context "authorized" do
      let!(:comments) { create_list(:comment, 2, commentable: question) }
      let!(:attachments) { create_list(:attachment, 2, attachable: question) }

      before do
        get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token
      end

      it "returns 200 status code" do
        expect(response).to be_success
      end

      context "comments" do
        it "returns list of comments" do
          expect(response.body).to have_json_size(2).at_path("question/comments")
        end

        %w(id user_id commentable_id commentable_type body created_at updated_at).each do |attr|
          it "comment object contains #{attr}" do
            comment = comments.first
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("question/comments/0/#{attr}")
          end
        end
      end

      context "attachments" do
        it "returns list of attached files" do
          expect(response.body).to have_json_size(2).at_path("question/attachments")
        end

        it "attachments object contains file" do
          attachment = attachments.first
          expect(response.body).to be_json_eql(attachment.send(:file).to_json).at_path("question/attachments/0/file")
        end
      end
    end



  end
end
