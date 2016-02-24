require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
	let!(:user) { create(:user) }
	let!(:question) { create(:question, user: user) }
  let!(:attachment) { create(:attachment, attachable: question)}

	before { login(user) }

	describe 'DELETE #destroy' do
	  context 'with correct user' do
	    it 'deletes answer' do
	      expect { delete :destroy, id: attachment, format: :js }.to change(Attachment, :count).by(-1)
	    end
	  end

	  context 'with incorrect user' do
	    let(:incorrect_user) { create(:user) }

	    before { login(incorrect_user) }

	    it 'does not allow to destroy' do
	      expect { delete :destroy, id: attachment, format: :js }.not_to change(Attachment, :count)
	    end

	    it 'returns forbidden' do
	      delete :destroy, id: attachment
	      expect(response).to be_forbidden
	    end
	  end
	end

end
