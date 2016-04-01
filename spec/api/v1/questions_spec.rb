require 'rails_helper'

describe "Questions API" do
  let(:access_token) { create :access_token }

  describe "GET /index" do
    it_behaves_like "API Authenticable"

    def do_request(options = {})
      get "/api/v1/questions", { format: :json }.merge(options)
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

    it_behaves_like "API Authenticable"

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", { format: :json }.merge(options)
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

  describe "/POST create" do
    it_behaves_like "API Authenticable"

    def do_request(options = {})
      get "/api/v1/questions", { format: :json }.merge(options)
    end

    context "authorized" do
      let!(:user) { create :user}
      let!(:access_token) { create(:access_token, resource_owner_id: user.id)}

      context "with valid attributes" do
        it "returns 200 status" do
          post "/api/v1/questions", question: attributes_for(:question), format: :json, access_token: access_token.token
          expect(response).to be_success
        end

        it "saves the question" do
          expect { post "/api/v1/questions", question: attributes_for(:question), format: :json, access_token: access_token.token }.to change(user.questions, :count).by(1)
        end
      end

      context "with invalid attributes" do
        it "returns 422 status" do
          post "/api/v1/questions", question: attributes_for(:invalid_question), format: :json, access_token: access_token.token
          expect(response.status).to eq 422
        end

        it "don't saves the question" do
          expect { post "/api/v1/questions", question: attributes_for(:invalid_question), format: :json, access_token: access_token.token }.to_not change(user.questions, :count)
        end
      end
    end
  end


end
