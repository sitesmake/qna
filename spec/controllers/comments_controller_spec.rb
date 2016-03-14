require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
	let(:user) { create(:user) }
	let(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question)}

	before { login(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new comment' do
        expect { post :create, id: answer.id, comment: attributes_for(:comment), format: :js }.to change(Comment, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'do not saves the new comment' do
        expect { post :create, id: answer.id, comment: attributes_for(:comment, body: nil), format: :js }.to_not change(Comment, :count)
      end
    end
  end

	describe 'DELETE #destroy' do
		let!(:comment) { create(:comment, commentable: question, user: user)}

	  context 'with correct user' do
	    it 'deletes comment' do
	      expect { delete :destroy, id: comment, format: :js }.to change(Comment, :count).by(-1)
	    end
	  end

	  context 'with incorrect user' do
	    let(:incorrect_user) { create(:user) }

	    before { login(incorrect_user) }

	    it 'does not allow to destroy' do
	      expect { delete :destroy, id: comment, format: :js }.not_to change(Comment, :count)
	    end

	    it 'returns forbidden' do
	      delete :destroy, id: comment
	      expect(response).to be_forbidden
	    end
	  end
	end

end
