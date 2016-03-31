require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #show' do
    before { get :show, id: question }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    let(:user) { create(:user) }

    before do
      login(user)
      get :new
    end

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns a current_user to @question' do
      expect(assigns(:question).user).to eq(user)
    end

    it 'renders new view' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user) }

    before { login(user) }

    context 'with valid attributes' do
      it 'saves the new question' do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end

      it 'assigns a current_user to @question' do
        post :create, question: attributes_for(:question)
        expect(assigns(:question).user).to eq(user)
      end

      it_behaves_like 'private_pub' do
        let(:channel) { "/questions" }
        let(:obj) { post :create, question: attributes_for(:question) }
      end
    end

    context 'with invalid attributes' do
      it 'does not save question' do
        expect { post :create, question: attributes_for(:invalid_question) }.not_to change(Question, :count)
      end

      it 'rerenders new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    before { login(user) }

    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, id: question, question: {title: 'new title 2', body: 'new body 2'}, format: :js
        question.reload
        expect(question.title).to eq 'new title 2'
        expect(question.body).to eq 'new body 2'
      end
    end

    context 'with invalid attributes' do
      it 'does not change question attributes' do
        old_title = question.title
        old_body = question.body
        patch :update, id: question, question: { title: 'new title 2', body: nil }, format: :js
        question.reload
        expect(question.title).to eq old_title
        expect(question.body).to eq old_body
      end
    end

    context 'with incorrect user' do
      before do
        question.user = create(:user)
        question.save!
      end

      it 'does not change question attributes' do
        old_title = question.title
        patch :update, id: question, question: { title: 'wrong title' }, format: :js
        question.reload
        expect(question.title).to eq old_title
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }

    before { login(user) }

    it 'deletes question' do
      expect { delete :destroy, id: question }.to change(Question, :count).by(-1)
    end

    it 'redirect to index view' do
      delete :destroy, id: question
      expect(response).to redirect_to questions_path
    end

    context 'with incorrect user' do
      before do
        question.user = create(:user)
        question.save!
      end

      it 'do not deletes question' do
        expect { delete :destroy, id: question }.not_to change(Question, :count)
      end

      it 'returns forbidden' do
        delete :destroy, id: question
        expect(response).to be_forbidden
      end
    end
  end

  describe "POST #vote" do
    let(:user) { create(:user) }
    before { login(user) }

    it 'assigns vote' do
      post :vote_up, id: question, format: :js
      expect(assigns(:vote)).to be_instance_of(Vote)
    end

    it 'votes up' do
      post :vote_up, id: question, format: :js
      expect(question.rating).to eq 1
    end

    it 'votes down' do
      post :vote_down, id: question, format: :js
      expect(question.rating).to eq -1
    end

    it 'returns correct json' do
      post :vote_up, id: question, format: :js
      parsed_response = JSON.parse(response.body)

      expect(parsed_response['id']).to eq question.id
    end

    it 'no double-voting' do
      create(:vote, user: user, votable_id: question.id, votable_type: "Question")
      post :vote_up, id: question, format: :js
      expect(response).to be_forbidden
    end

    it 'author can not vote for his question' do
      question.user = user
      question.save!
      post :vote_up, id: question, format: :js
      expect(response).to be_forbidden
    end
  end

  describe "DELETE #cancel_vote" do
    let(:user) { create(:user) }
    let!(:vote) { create(:vote, user: user, votable_id: question.id, votable_type: "Question") }

    before { login(user) }

    it "destroys the vote" do
      expect { delete :cancel_vote, id: question }.to change(Vote, :count).by(-1)
    end

    it "returns correct json" do
      delete :cancel_vote, id: question
      parsed_response = JSON.parse(response.body)

      expect(parsed_response['id']).to eq question.id
    end
  end

end
