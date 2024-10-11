require 'swagger_helper'

RSpec.describe 'Feed API', type: :request do
  let(:user) { create(:user) }
  let(:profile) { create(:profile, user: user) }
  let(:token) { Warden::JWTAuth::UserEncoder.new.call(profile, :profile, nil).first }
  let(:Authorization) { "Bearer #{token}" }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  path '/feed' do
    get 'Retrieves user feed' do
      tags 'Feed'
      security [bearer_auth: []]
      produces 'application/json'

      response '200', 'feed retrieved' do
        schema type: :object,
               properties: {
                 feed: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       content: { type: :string },
                       author: {
                         type: :object,
                         properties: {
                           id: { type: :integer },
                           username: { type: :string }
                         }
                       },
                       created_at: { type: :string, format: 'date-time' }
                     }
                   }
                 }
               }

        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { 'invalid_token' }
        run_test!
      end
    end
  end
end
