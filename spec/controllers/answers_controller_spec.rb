require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question) }

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
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new question' do
        expect { post :create, question_id: question, answer: attributes_for(:answer) }.to change(question.answers, :count).by(1)
      end

      it 'redirects to question view' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(question)
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

    it 'creates answer with logged-in user' do
      post :create, question_id: question, answer: attributes_for(:answer)
      expect(assigns(:answer).user).to eq(@user)
    end
  end

  describe 'GET #edit' do
    sign_in_user

    let(:answer) { create(:answer, user: @user) }

    before { get :edit, question_id: question, id: answer }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq(answer)
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end

    it 'does not allow to edit for other user' do
      answer = create(:answer, user: create(:user))

      get :edit, question_id: question, id: answer

      expect(response).to redirect_to question
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    let!(:answer) { create(:answer, user: @user) }

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
    end

    context 'with invalid attributes' do
      before { patch :update, question_id: question, id: answer, answer: attributes_for(:answer, body: nil) }

      it 'does not change answer attributes' do
        answer.reload
        expect(answer.body).to eq 'Answer text'
      end

      it 'rerenders edit view' do
        expect(response).to render_template :edit
      end
    end

    it 'does not allow to update for other user' do
      answer = create(:answer, user: create(:user))

      patch :update, question_id: question, id: answer, answer: attributes_for(:answer)

      expect(response).to redirect_to question
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    let!(:answer) { create(:answer, question: question, user: @user) }

    it 'deletes answer' do
      expect { delete :destroy, question_id: question, id: answer }.to change(question.answers, :count).by(-1)
    end

    it 'redirect to question view' do
      delete :destroy, question_id: question, id: answer
      expect(response).to redirect_to question
    end

    it 'does not allow to destroy for other user' do
      answer = create(:answer, user: create(:user))

      delete :destroy, question_id: question, id: answer

      expect(response).to redirect_to question
    end
  end
end
