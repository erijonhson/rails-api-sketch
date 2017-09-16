require 'rails_helper'

RSpec.describe 'Task API' do

  let!(:user) { create(:user) }
  let(:headers) do
    {
        'Content-Type' => Mime[:json].to_s,
        'Authorization' => user.auth_token
    }
  end

  describe 'GET /api/v1/tasks' do
    before do
      create_list(:task, 5, user_id: user.id)
      get '/api/v1/tasks', params: {}, headers: headers
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns 5 tasks from database' do
      expect(json_body[:tasks].count).to eq(5)
    end
  end

  describe 'GET /api/v1/tasks/:id' do
    let(:task) { create(:task, user_id: user.id) }

    before { get "/api/v1/tasks/#{task.id}", params: {}, headers: headers }

    it 'returns status code 200' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns the json for task' do
      expect(json_body[:title]).to eq(task.title)
    end
  end

  describe 'POST /api/v1/tasks' do
    let(:task_params) { attributes_for(:task) }

    before do
      post '/api/v1/tasks/', params: { task: task_params }.to_json, headers: headers
    end

    context 'when the params are valid' do

      it 'returns status code 201' do
        expect(response).to have_http_status(:created)
      end

      it 'saves the task in the database' do
        expect( Task.find_by(title: task_params[:title]) ).not_to be_nil
      end

      it 'returns the json for created task' do
        expect(json_body[:title]).to eq(task_params[:title])
      end

      it 'assigns the created task to the current user' do
        expect(json_body[:user_id]).to eq(user.id)
      end
    end

    context 'when the params are invalid' do
      let(:task_params) { attributes_for(:task, title: ' ') }

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'doesn\'t saves the task in the database' do
        expect( Task.find_by(title: task_params[:title]) ).to be_nil
      end

      it 'returns the json error for title' do
        expect(json_body[:errors]).to have_key(:title)
      end
    end
  end

  describe 'PUT /api/v1/tasks/:id' do
    let(:task) { create(:task, user_id: user.id) }

    before do
      put "/api/v1/tasks/#{task.id}", params: { task: task_params }.to_json, headers: headers
    end

    context 'when the params are valid' do
      let(:task_params) { { title: 'New task title' } }

      it 'returns status code 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the json for updated task' do
        expect(json_body[:title]).to eq(task_params[:title])
      end

      it 'updates the task in the database' do
        expect( Task.find_by(title: task_params[:title]) ).not_to be_nil
      end
    end

    context 'when the params are invalid' do
      let(:task_params) { { title: ' ' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the json error for title' do
        expect(json_body[:errors]).to have_key(:title)
      end

      it 'doesn\'t updates the task in the database' do
        expect( Task.find_by(title: task_params[:title]) ).to be_nil
      end
    end
  end

  describe 'DELETE /api/v1/tasks/:id' do
    let(:task) { create(:task, user_id: user.id) }

    before do
      delete "/api/v1/tasks/#{task.id}", params: {}, headers: headers
    end

    it 'returns status code 204' do
      expect(response).to have_http_status(:no_content)
    end

    it 'removes the task from the database' do
      expect { Task.find(task.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

end