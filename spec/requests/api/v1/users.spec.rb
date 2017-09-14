require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let!(:user) { create(:user) }
  let(:user_id) { user.id }

  before { host! 'api.rails-api-skecth.dev' }

  describe 'GET /users/:id' do
    before do
      headers = { 'Accept' => 'application/vnd.rails-api-skecth.v1' }
      get "/users/#{user_id}", params: {}, headers: headers
    end

    context 'when the user exists' do
      it 'returns the user' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:id]).to eq(user_id)
      end

      it 'return status 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the user doesn\'t exists' do
      let(:user_id) { 999 }

      it 'return status 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'POST /users' do
    before do
      headers = { 'Accept' => 'application/vnd.rails-api-skecth.v1' }
      post '/users', params: { user: user_params }, headers: headers
    end

    context 'when the request params are valid' do
      let(:user_params) { attributes_for(:user) }

      it 'return status 201' do
        expect(response).to have_http_status(201)
      end

      it 'return json data for the created user' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eq(user_params[:email])
      end
    end

    context 'when the request params are invalid' do
      let(:user_params) { attributes_for(:user, email: 'invalidatemail.com') }

      it 'return status 422' do
        expect(response).to have_http_status(422)
      end

      it 'return json data for the errors' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:erros)
      end
    end
  end

  describe 'PUT /users/:id' do
    before do
      headers = { 'Accept' => 'application/vnd.rails-api-skecth.v1' }
      put "/users/#{user_id}", params: { user: user_params }, headers: headers
    end

    context 'when the request params are valid' do
      let(:user_params) { { email: 'new-rails-api-skecth@email.com' } }

      it 'return status 200' do
        expect(response).to have_http_status(200)
      end

      it 'return json data for the updated user' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eq(user_params[:email])
      end
    end

    context 'when the request params are invalid' do
      let(:user_params) { attributes_for(:user, email: 'invalidatemail.com') }

      it 'return status 422' do
        expect(response).to have_http_status(422)
      end

      it 'return json data for the errors' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:erros)
      end
    end
  end

end