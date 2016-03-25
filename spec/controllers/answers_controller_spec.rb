require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question) }
  let(:user) { create(:user) }

  before { login(user) }

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, user: user) }

    it 'assigns the requested answer to @answer' do
      patch :update, id: answer, answer: attributes_for(:answer), format: :js

      expect(assigns(:answer)).to eq answer
    end

    it 'changes answer attributes' do
      patch :update, id: answer, answer: { body: 'new body 2' }, format: :js

      answer.reload

      expect(answer.body).to eq 'new body 2'
    end

    it 'does not allow to update for other user' do
      answer = create(:answer, body: 'constanta')

      patch :update, id: answer, answer: attributes_for(:answer), format: :js

      answer.reload

      expect(answer.body).to eq 'constanta'
    end
  end

  describe 'POST #set_best' do
    let!(:answer) { create(:answer) }

    context 'with correct user' do
      before do
        answer.question.update_attributes(user: user)
        post :set_best, id: answer, format: :js
      end

      it 'assigns the requested answer to @answer' do
        expect(assigns(:answer)).to eq answer
      end

      it 'sets the correct question' do
        expect(assigns(:question)).to eq answer.question
      end

      it 'sets the best answer' do
        answer.reload
        expect(answer).to be_best
      end
    end

    context 'with incorrect user' do
      before { post :set_best, id: answer, format: :js }

      it 'does not allow to set_best' do
        answer.reload
        expect(answer).to_not be_best
      end

      it 'returns forbidden' do
        expect(response).to be_forbidden
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'with correct user' do
      it 'deletes answer' do
        expect { delete :destroy, id: answer, format: :js }.to change(question.answers, :count).by(-1)
      end
    end

    context 'with incorrect user' do
      let(:incorrect_user) { create(:user) }

      before { login(incorrect_user) }

      it 'does not allow to destroy' do
        expect { delete :destroy, id: answer, format: :js }.not_to change(question.answers, :count)
      end

      it 'returns forbidden' do
        delete :destroy, id: answer
        expect(response).to be_forbidden
      end
    end
  end
end
