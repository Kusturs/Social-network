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
      security [ bearer_auth: [] ]
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
                username: { type: :string },
                first_name: { type: :string },
                second_name: { type: :string },
                last_name: { type: :string },
                posts: {
                  type: :array,
                  items: {
                    type: :object,
                    properties: {
                      id: { type: :integer },
                      content: { type: :string }
                    }
                  }
                },
                comments: {
                  type: :array,
                  items: {
                    type: :object,
                    properties: {
                      id: { type: :integer },
                      content: { type: :string }
                    }
                  }
                }
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
        }

        run_test!
      end
    end

    post 'Creates a user' do
      tags 'Users'
      security [ bearer_auth: [] ]
      consumes 'application/json'

      parameter name: :user_params, in: :body, schema: {
        type: :object,
        properties: {
          username: { type: :string },
          first_name: { type: :string },
          second_name: { type: :string },
          last_name: { type: :string }
        },
        required: [ 'username' ]
      }

      response '201', 'user created' do
        let(:user_params) { { username: 'newuser', first_name: 'New', last_name: 'User' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:user_params) { { username: '' } }
        run_test!
      end
    end
  end

  path '/users/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'user id'

    get 'Retrieves a user' do
      tags 'Users'
      security [ bearer_auth: [] ]
      produces 'application/json'

      response '200', 'user found' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            username: { type: :string },
            first_name: { type: :string },
            second_name: { type: :string },
            last_name: { type: :string },
            posts: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  content: { type: :string }
                }
              }
            },
            comments: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  content: { type: :string }
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

    put 'Updates a user' do
      tags 'Users'
      security [ bearer_auth: [] ]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user_params, in: :body, schema: {
        type: :object,
        properties: {
          username: { type: :string },
          first_name: { type: :string },
          second_name: { type: :string },
          last_name: { type: :string }
        }
      }

      response '200', 'user updated' do
        let(:id) { existing_user.id }
        let(:user_params) { { first_name: 'Updated', last_name: 'Name' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:id) { existing_user.id }
        let(:user_params) { { username: '' } }
        run_test!
      end
    end

    delete 'Deletes a user' do
      tags 'Users'
      security [ bearer_auth: [] ]

      response '204', 'user deleted' do
        let(:id) { existing_user.id }
        run_test!
      end
    end
  end

  # path '/users/me' do
  #   get 'Retrieves current user and feed' do
  #     tags 'Users'
  #     security [ bearer_auth: [] ]
  #     produces 'application/json'

  #     response '200', 'current user and feed found' do
  #       schema type: :object,
  #         properties: {
  #           user: {
  #             type: :object,
  #             properties: {
  #               id: { type: :integer },
  #               username: { type: :string },
  #               first_name: { type: :string },
  #               second_name: { type: :string },
  #               last_name: { type: :string }
  #             }
  #           },
  #           feed: {
  #             type: :array,
  #             items: {
  #               type: :object,
  #               properties: {
  #                 id: { type: :integer },
  #                 content: { type: :string },
  #                 author: {
  #                   type: :object,
  #                   properties: {
  #                     id: { type: :integer },
  #                     username: { type: :string }
  #                   }
  #                 },
  #                 created_at: { type: :string, format: 'date-time' }
  #               }
  #             }
  #           }
  #         }

  #       run_test!
  #     end
  #   end
  # end
end
