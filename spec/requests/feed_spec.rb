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
               },
               example: {
                 feed: [
                   {
                     id: 1,
                     content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dol.',
                     author: {
                       id: 1,
                       first_name: 'Lorem',
                       last_name: 'Ipsum',
                       username: 'lorem_ipsum',
                       second_name: 'Dolor'
                     },
                     comments_count: 5
                   },
                   {
                     id: 2,
                     content: 'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                     author: {
                       id: 2,
                       first_name: 'Duis',
                       last_name: 'Aute',
                       username: 'duis_aute',
                       second_name: 'Irure'
                     },
                     comments_count: 3
                   }
                 ],
                 pagination: {
                   count: 100,
                   page: 1,
                   items: 20,
                   pages: 5
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
