require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question) }
  let(:user) { create(:user) }

  before { login(user) }

  # describe 'GET #new' do
  #   sign_in_user

  #   before { get :new, question_id: question }

  #   it 'assigns a new Answer to @answer' do
  #     expect(assigns(:answer)).to be_a_new(Answer)
  #   end

  #   it 'renders new view' do
  #     expect(response).to render_template(:new)
  #   end

  # end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new question' do
        expect { post :create, question_id: question, answer: attributes_for(:answer) }.to change(question.answers, :count).by(1)
      end

      it 'redirects to question view' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(question)
      end

      it 'creates answer with logged-in user' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(assigns(:answer).user).to eq(user)
      end
    end

    context 'with invalid attributes' do
      it 'does not save answer' do
        expect { post :create, question_id: question, answer: attributes_for(:answer, body: nil) }.not_to change(Answer, :count)
      end

      it 'redirect to question page' do
        post :create, question_id: question, answer: attributes_for(:answer, body: nil)
        expect(response).to redirect_to question_path(question)
      end
    end
  end

  describe 'GET #edit' do
    let(:answer) { create(:answer, user: user) }

    before do
      get :edit, question_id: question, id: answer
    end

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq(answer)
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end

    it 'does not allow to edit for other user' do
      answer = create(:answer)

      get :edit, question_id: question, id: answer

      expect(response).to redirect_to question
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, user: user) }

    context 'with valid attributes' do
      it 'assigns the requested answer to @answer' do
        patch :update, question_id: question, id: answer, answer: attributes_for(:answer)
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, question_id: question, id: answer, answer: { body: 'new body 2' }
        answer.reload
        expect(answer.body).to eq 'new body 2'
      end

      it 'redirects to the updated answer question' do
        patch :update, question_id: question, id: answer, answer: attributes_for(:answer)
        expect(response).to redirect_to question
      end

      it 'does not allow to update for other user' do
        answer = create(:answer)

        patch :update, question_id: question, id: answer, answer: attributes_for(:answer)

        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        initial_text = answer.body
        patch :update, question_id: question, id: answer, answer: attributes_for(:answer, body: nil)
        answer.reload
        expect(answer.body).to eq initial_text
      end

      it 'rerenders edit view' do
        patch :update, question_id: question, id: answer, answer: attributes_for(:answer, body: nil)
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'with correct user' do
      it 'deletes answer' do
        expect { delete :destroy, question_id: question, id: answer }.to change(question.answers, :count).by(-1)
      end

      it 'redirect to question view' do
        delete :destroy, question_id: question, id: answer
        expect(response).to redirect_to question
      end
    end

    context 'with incorrect user' do
      let(:incorrect_user) { create(:user) }

      before { login(incorrect_user) }

      it 'does not allow to destroy' do
        expect { delete :destroy, question_id: question, id: answer }.not_to change(question.answers, :count)
      end

      it 'redirect to question' do
        delete :destroy, question_id: question, id: answer
        expect(response).to redirect_to question
      end
    end
  end
end
