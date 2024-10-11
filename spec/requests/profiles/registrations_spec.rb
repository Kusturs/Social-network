require 'swagger_helper'

RSpec.describe 'Profiles::Registrations API', type: :request do
  path '/signup' do
    post 'Creates a new profile and user' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :registration_params, in: :body, schema: {
        type: :object,
        properties: {
          profile: {
            type: :object,
            properties: {
              email: { type: :string },
              password: { type: :string },
              password_confirmation: { type: :string }
            },
            required: %w[email password password_confirmation]
          },
          user: {
            type: :object,
            properties: {
              username: { type: :string },
              first_name: { type: :string },
              last_name: { type: :string }
            },
            required: %w[username first_name last_name]
          }
        },
        required: ['profile', 'user']
      }

      response '201', 'profile created' do
        let(:registration_params) do
          {
            profile: {
              email: 'test@example.com',
              password: 'password123',
              password_confirmation: 'password123'
            },
            user: {
              username: 'testuser',
              first_name: 'Test',
              last_name: 'User'
            }
          }
        end

        schema type: :object,
               properties: {
                 message: { type: :string },
                 profile: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     email: { type: :string },
                     user: {
                       type: :object,
                       properties: {
                         id: { type: :integer },
                         username: { type: :string },
                         first_name: { type: :string },
                         last_name: { type: :string }
                       }
                     }
                   }
                 }
               }

        run_test!
      end

      response '422', 'invalid request' do
        let(:registration_params) do
          {
            profile: {
              email: 'invalid_email',
              password: 'short',
              password_confirmation: 'mismatch'
            },
            user: {
              username: '',
              first_name: '',
              last_name: ''
            }
          }
        end

        schema type: :object,
               properties: {
                 errors: {
                   type: :array,
                   items: { type: :string }
                 }
               }

        run_test!
      end
    end
  end
end
