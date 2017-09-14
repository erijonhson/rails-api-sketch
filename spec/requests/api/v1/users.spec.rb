require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let!(:user) { create(:user) }
  let(:user_id) { user.id }

  before { host! "api.rails-api-skecth.dev" }

  describe "GET /users/:id" do
    before do
      headers = { "Accept" => "application/vnd.rails-api-skecth.v1" }
      get "/users/#{user_id}", params: {}, headers: headers
    end

    context "when the user exists" do
      it "returns the user" do
        user_response = JSON.parse(response.body)
        expect(user_response["id"]).to eq(user_id)
      end

      it "return status 200" do
        expect(response).to have_http_status(200)
      end
    end

    context "when the user doesn't exists" do
      let(:user_id) { 999 }

      it "return status 404" do
        expect(response).to have_http_status(404)
      end
    end
  end

end