shared_examples_for "Votable" do |object_name|
  describe "POST #vote" do
    let(:user) { create(:user) }
    before { login(user) }

    it 'assigns vote' do
      post :vote_up, id: object, format: :js
      expect(assigns(:vote)).to be_instance_of(Vote)
    end

    it 'votes up' do
      post :vote_up, id: object, format: :js
      expect(object.rating).to eq 1
    end

    it 'votes down' do
      post :vote_down, id: object, format: :js
      expect(object.rating).to eq -1
    end

    it 'returns correct json' do
      post :vote_up, id: object, format: :js
      parsed_response = JSON.parse(response.body)

      expect(parsed_response['id']).to eq object.id
    end

    it 'no double-voting' do
      create(:vote, user: user, votable_id: object.id, votable_type: "#{object.class.to_s}")
      post :vote_up, id: object, format: :js
      expect(response).to be_forbidden
    end

    it "author can not vote for his #{object_name}" do
      object.user = user
      object.save!
      post :vote_up, id: object, format: :js
      expect(response).to be_forbidden
    end
  end

  describe "DELETE #cancel_vote" do
    let(:user) { create(:user) }
    let!(:vote) { create(:vote, user: user, votable_id: object.id, votable_type: "#{object.class.to_s}") }

    before { login(user) }

    it "destroys the vote" do
      expect { delete :cancel_vote, id: object }.to change(Vote, :count).by(-1)
    end

    it "returns correct json" do
      delete :cancel_vote, id: object
      parsed_response = JSON.parse(response.body)

      expect(parsed_response['id']).to eq object.id
    end
  end
end