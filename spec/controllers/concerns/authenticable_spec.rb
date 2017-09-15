require 'rails_helper'

RSpec.describe Authenticable do
  # anonymous controller
  controller(ApplicationController) do
    include Authenticable
  end

  # subject pointer to controller
  let(:app_controller) { subject }

  describe '#current_user' do
    let(:user) { create(:user) }

    before do
      req = double(:headers => { 'Authorization' => user.auth_token })
      allow(app_controller).to receive(:request).and_return(req)
    end

    it 'returns the user from the authorization header' do
      expect(app_controller.current_user).to eq(user)
    end
  end

  describe '#authenticate_with_token!!' do
    controller do
      before_action :authenticate_with_token!
      def restricted_action; end
    end

    context 'when there is no user logged in' do
      before do
        allow(app_controller).to receive(:current_user).and_return(nil)
        routes.draw { get 'restricted_action' => 'anonymous#restricted_action' }
        get :restricted_action
      end

      it 'return status code 401' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end
end