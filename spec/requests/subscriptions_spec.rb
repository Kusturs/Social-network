require 'swagger_helper'

RSpec.describe 'Subscriptions API', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:profile) { create(:profile, user: user) }
  let(:token) { Warden::JWTAuth::UserEncoder.new.call(profile, :profile, nil).first }
  let(:Authorization) { "Bearer #{token}" }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  path '/subscriptions' do
    post 'Follow a user' do
      tags 'Subscriptions'
      security [bearer_auth: []]
      produces 'application/json'
      consumes 'application/json'
      parameter name: :id, in: :body, schema: {
        type: :object,
        properties: {
          id: { type: :integer }
        },
        required: ['id']
      }

      response '201', 'User followed successfully' do
        let(:id) { { id: other_user.id } }

        run_test! do |response|
          expect(response).to have_http_status(:created)
          json_response = JSON.parse(response.body)
          expect(json_response['message']).to eq('User followed successfully')
          expect(json_response['followed_id']).to eq(other_user.id)
        end
      end

      response '422', 'Unable to follow user' do
        let(:id) { { id: other_user.id } }

        before do
          allow_any_instance_of(User).to receive(:follow).and_return(false)
        end

        run_test! do |response|
          expect(response).to have_http_status(:unprocessable_entity)
          json_response = JSON.parse(response.body)
          expect(json_response['error']).to eq('Unable to follow user')
        end
      end

      response '404', 'User not found' do
        let(:id) { { id: 0 } }
        run_test! do |response|
          expect(response).to have_http_status(:not_found)
          json_response = JSON.parse(response.body)
          expect(json_response['error']).to include("Couldn't find User")
        end
      end
    end
  end

  path '/subscriptions/{id}' do
    delete 'Unfollow a user' do
      tags 'Subscriptions'
      security [bearer_auth: []]
      produces 'application/json'
      parameter name: 'id', in: :path, type: :integer, required: true

      response '200', 'User unfollowed successfully' do
        let(:id) { other_user.id }

        before do
          user.follow(other_user)
        end

        run_test! do |response|
          expect(response).to have_http_status(:ok)
          json_response = JSON.parse(response.body)
          expect(json_response['message']).to eq('User unfollowed successfully')
          expect(json_response['followed_id']).to eq(other_user.id)
        end
      end

      response '422', 'Unable to unfollow user' do
        let(:id) { other_user.id }

        before do
          allow_any_instance_of(User).to receive(:unfollow).and_return(false)
        end

        run_test! do |response|
          expect(response).to have_http_status(:unprocessable_entity)
          json_response = JSON.parse(response.body)
          expect(json_response['error']).to eq('Unable to unfollow user')
        end
      end

      response '404', 'User not found' do
        let(:id) { 0 }
        run_test! do |response|
          expect(response).to have_http_status(:not_found)
          json_response = JSON.parse(response.body)
          expect(json_response['error']).to include("Couldn't find User")
        end
      end
    end
  end
end
