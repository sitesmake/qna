require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question) }
  let(:user) { create(:user) }

  before { login(user) }

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

    it 'assigns the requested answer to @answer' do
      patch :update, question_id: question, id: answer, answer: attributes_for(:answer), format: :js
      expect(assigns(:answer)).to eq answer
    end

    it 'changes answer attributes' do
      patch :update, question_id: question, id: answer, answer: { body: 'new body 2' }, format: :js
      answer.reload
      expect(answer.body).to eq 'new body 2'
    end

    it 'does not allow to update for other user' do
      answer = create(:answer)

      patch :update, question_id: question, id: answer, answer: attributes_for(:answer), format: :js

      expect(response).to redirect_to question
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
