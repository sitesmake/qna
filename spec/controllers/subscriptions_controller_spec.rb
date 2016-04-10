require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let!(:question) { create(:question) }

  describe "POST #create" do
    let(:user) { create(:user) }

    context "with logged user" do
      before { login(user) }

      it "subscribes user" do
        post :create, question_id: question.id, format: :js
        expect(user.subscribed_for?(question)).to be true
      end

      it "assigns question to @question" do
        post :create, question_id: question.id, format: :js
        expect(assigns(:question)).to eq(question)
      end

      it "renders create template" do
        post :create, question_id: question.id, format: :js
        expect(response).to render_template :create
      end
    end

    context "with guest" do
      it "do not change subscriptions count" do
        expect { post :create, question_id: question.id, format: :js }.to_not change(Subscription, :count)
      end

      it "returns forbidden" do
        post :create, question_id: question.id, format: :js
        expect(response.status).to eq 401
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:subscription) { question.subscriptions.first }
    let(:user) { create(:user) }

    context "with logged user" do

      before { login(user) }

      it "unsubscribes user" do
        delete :destroy, id: subscription.id, format: :js
        expect(user.subscribed_for?(question)).to be false
      end

      it "assigns subscription to @subscription" do
        delete :destroy, id: subscription.id, format: :js
        expect(assigns(:subscription)).to eq(subscription)
      end

      it "renders destroy template" do
        delete :destroy, id: subscription.id, format: :js
        expect(response).to render_template :destroy
      end
    end

    context "with guest" do
      it "do not change subscriptions count" do
        expect { delete :destroy, id: subscription.id, format: :js }.to_not change(Subscription, :count)
      end

      it "returns forbidden" do
        delete :destroy, id: subscription.id, format: :js
        expect(response.status).to eq 401
      end
    end

    # context "with guest" do
    #   let!(:question) { create(:question) }

    #   it "do not change subscriptions count" do
    #     expect { post :create, question_id: question.id, format: :js }.to_not change(Subscription, :count)
    #   end

    #   it "returns forbidden" do
    #     post :create, question_id: question.id, format: :js
    #     expect(response.status).to eq 401
    #   end
    # end
  end

  #     it "unsubscribe from subscribed status" do
  #       user.toggle_subscription(question)
  #       patch :toggle_subscription, id: question.id, format: :js
  #       expect(user.subscribed_for?(question)).to be false
  #     end

  #     it "renders toggle_subscription template" do
  #       patch :toggle_subscription, id: question.id, format: :js
  #       expect(response).to render_template :toggle_subscription
  #     end
  #   end

  #   context "with guest user" do
  #     let!(:question) { create(:question) }
  #     it "do not change subscriptions count" do
  #       expect { patch :toggle_subscription, id: question.id, format: :js }.to_not change(Subscription, :count)
  #     end

  #     it "returns forbidden" do
  #       patch :toggle_subscription, id: question.id, format: :js
  #       expect(response.status).to eq 401
  #     end
  #   end
  # end

end
