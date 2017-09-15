require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let!(:user) { create(:user) }
  let(:user_id) { user.id }
  let(:headers) do
    {
      'Accept' => 'application/vnd.rails-api-sketch.v2',
      'Content-Type' => Mime[:json].to_s,
      'Authorization' => user.auth_token
    }
  end

  before { host! 'api.rails-api-skecth.dev' }

  describe 'GET /users/:id' do
    before do
      get "/users/#{user_id}", params: {}, headers: headers
    end

    context 'when the user exists' do
      it 'returns the user' do
        expect(json_body[:data][:id].to_i).to eq(user_id)
      end

      it 'return status 200' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the user doesn\'t exists' do
      let(:user_id) { 999 }

      it 'return status 404' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /users' do
    before do
      post '/users', params: { user: user_params }.to_json, headers: headers
    end

    context 'when the request params are valid' do
      let(:user_params) { attributes_for(:user) }

      it 'return status 201' do
        expect(response).to have_http_status(201)
      end

      it 'return json data for the created user' do
        expect(json_body[:data][:attributes][:email]).to eq(user_params[:email])
      end
    end

    context 'when the request params are invalid' do
      let(:user_params) { attributes_for(:user, email: 'invalidatemail.com') }

      it 'return status 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'return json data for the errors' do
        expect(json_body).to have_key(:erros)
      end
    end
  end

  describe 'PUT /users/:id' do
    before do
      put "/users/#{user_id}", params: { user: user_params }.to_json, headers: headers
    end

    context 'when the request params are valid' do
      let(:user_params) { { email: 'new-rails-api-skecth@email.com' } }

      it 'return status 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'return json data for the updated user' do
        expect(json_body[:data][:attributes][:email]).to eq(user_params[:email])
      end
    end

    context 'when the request params are invalid' do
      let(:user_params) { attributes_for(:user, email: 'invalidatemail.com') }

      it 'return status 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'return json data for the errors' do
        expect(json_body).to have_key(:erros)
      end
    end
  end

  describe 'DELETE /users/:id' do
    before do
      delete "/users/#{user_id}", params: {}, headers: headers
    end

    it 'return status 204' do
      expect(response).to have_http_status(:no_content)
    end

    it 'removes the user from database' do
      expect( User.find_by(id: :user_id) ).to be_nil
    end
  end
end