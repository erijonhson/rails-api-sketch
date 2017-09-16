require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let!(:user) { create(:user) }
  let(:auth_data) { user.create_new_auth_token }
  let(:headers) do
    {
      'Accept' => 'application/vnd.rails-api-sketch.v2',
      'Content-Type' => Mime[:json].to_s,
      'access-token' => auth_data['access-token'],
      'uid' => auth_data['uid'],
      'client' => auth_data['client']
    }
  end

  before { host! 'api.rails-api-sketch.dev' }

  describe 'GET /auth/validate_token' do

    context 'when the request headers are valid' do
      before do
        get '/auth/validate_token', params: {}, headers: headers
      end

      it 'returns the user id' do
        expect(json_body[:data][:id].to_i).to eq(user.id)
      end

      it 'return status 200' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the request headers are invalid' do
      before do
        headers['access-token'] = 'invalide'
        get '/auth/validate_token', params: {}, headers: headers
      end

      it 'return status 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /auth' do
    before do
      post '/auth', params: user_params.to_json, headers: headers
    end

    context 'when the request params are valid' do
      let(:user_params) { attributes_for(:user) }

      it 'return status 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'return json data for the created user' do
        expect(json_body[:data][:email]).to eq(user_params[:email])
      end
    end

    context 'when the request params are invalid' do
      let(:user_params) { attributes_for(:user, email: 'invalidatemail.com') }

      it 'return status 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'return json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'PUT /auth' do
    before do
      put '/auth', params: user_params.to_json, headers: headers
    end

    context 'when the request params are valid' do
      let(:user_params) { { email: 'new-rails-api-skecth@email.com' } }

      it 'return status 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'return json data for the updated user' do
        expect(json_body[:data][:email]).to eq(user_params[:email])
      end
    end

    context 'when the request params are invalid' do
      let(:user_params) { attributes_for(:user, email: 'invalidatemail.com') }

      it 'return status 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'return json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /auth' do
    before do
      delete '/auth', params: {}, headers: headers
    end

    it 'return status 200' do
      expect(response).to have_http_status(:ok)
    end

    it 'removes the user from database' do
      expect( User.find_by(id: user.id) ).to be_nil
    end
  end
end