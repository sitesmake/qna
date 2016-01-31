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

    it 'assigns the requested question answers to @answers' do
      answer1 = create(:answer, question: question)
      answer2 = create(:answer)
      answer3 = create(:answer, question: question)

      expect(assigns(:answers)).to eq [answer1, answer3]
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns a current_user to @question' do
      expect(assigns(:question).user).to eq(@user)
    end

    it 'renders new view' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    sign_in_user

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
        expect(assigns(:question).user).to eq(@user)
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

  describe 'GET #edit' do
    sign_in_user

    let(:question) { create(:question, user: @user) }

    before { get :edit, id: question }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq(question)
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end

    it 'redirects to question with incorrect user' do
      question.user = create(:user)
      question.save!

      get :edit, id: question

      expect(response).to redirect_to question_path
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    let(:question) { create(:question, user: @user) }

    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, id: question, question: {title: 'new title 2', body: 'new body 2'}
        question.reload
        expect(question.title).to eq 'new title 2'
        expect(question.body).to eq 'new body 2'
      end

      it 'redirects to the updated question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it 'does not change question attributes' do
        old_title = question.title
        old_body = question.body
        patch :update, id: question, question: { title: 'new title 2', body: nil }
        question.reload
        expect(question.title).to eq old_title
        expect(question.body).to eq old_body
      end

      it 'rerenders edit view' do
        patch :update, id: question, question: { title: 'new title 2', body: nil }
        expect(response).to render_template :edit
      end
    end

    context 'with incorrect user' do
      before do
        question.user = create(:user)
        question.save!
      end

      it 'does not change question attributes' do
        old_title = question.title
        patch :update, id: question, question: { title: 'wrong title' }
        question.reload
        expect(question.title).to eq old_title
      end

      it 'redirects to question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(response).to redirect_to question_path
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    let(:question) { create(:question, user: @user) }

    it 'deletes question' do
      question
      expect { delete :destroy, id: question }.to change(Question, :count).by(-1)
    end

    it 'redirect to index view' do
      question
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

      it 'redirects to question' do
        delete :destroy, id: question
        expect(response).to redirect_to question_path
      end
    end
  end


end
