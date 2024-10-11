require 'swagger_helper'

RSpec.describe 'Users API', type: :request do
  let(:user) { create(:user) }
  let(:profile) { create(:profile, user: user) }
  let(:token) { Warden::JWTAuth::UserEncoder.new.call(profile, :profile, nil).first }
  let(:Authorization) { "Bearer #{token}" }
  let(:existing_user) { create(:user) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  path '/users' do
    get 'Lists all users' do
      tags 'Users'
      security [bearer_auth: []]
      produces 'application/json'

      response '200', 'users found' do
        schema type: :object,
               properties: {
                 users: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       first_name: { type: :string },
                       last_name: { type: :string },
                       username: { type: :string },
                       second_name: { type: :string }
                     }
                   }
                 },
                 pagination: {
                   type: :object,
                   properties: {
                     count: { type: :integer },
                     page: { type: :integer },
                     items: { type: :integer },
                     pages: { type: :integer }
                   }
                 }
               },
               example: {
                 users: [
                   {
                     id: 1,
                     first_name: 'Lorem',
                     last_name: 'Ipsum',
                     username: 'lorem_ipsum',
                     second_name: 'Dolor'
                   },
                   {
                     id: 2,
                     first_name: 'Sit',
                     last_name: 'Amet',
                     username: 'sit_amet',
                     second_name: 'Consectetur'
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
    end
  end

  path '/users/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'user id'

    get 'Retrieves a user' do
      tags 'Users'
      security [bearer_auth: []]
      produces 'application/json'

      response '200', 'user found' do
        schema type: :object,
               properties: {
                 id: { type: :integer, example: 1 },
                 username: { type: :string, example: 'lorem_ipsum' },
                 first_name: { type: :string, example: 'Lorem' },
                 second_name: { type: :string, example: 'Dolor' },
                 last_name: { type: :string, example: 'Ipsum' },
                 posts: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer, example: 1 },
                       content: { type: :string, example: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.' },
                       comments_count: { type: :integer, example: 5 }
                     }
                   }
                 }
               }

        let(:id) { existing_user.id }
        run_test!
      end

      response '404', 'user not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
