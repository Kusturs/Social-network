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
              email: { type: :string, example: 'user@example.com' },
              password: { type: :string, example: 'password123' },
              password_confirmation: { type: :string, example: 'password123' }
            },
            required: %w[email password password_confirmation]
          },
          user: {
            type: :object,
            properties: {
              username: { type: :string, example: 'username' },
              first_name: { type: :string, example: 'John' },
              last_name: { type: :string, example: 'Doe' }
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
                 message: { type: :string, example: 'Signed up successfully.' },
                 profile: {
                   type: :object,
                   properties: {
                     id: { type: :integer, example: 1 },
                     email: { type: :string, example: 'test@example.com' },
                     user: {
                       type: :object,
                       properties: {
                         id: { type: :integer, example: 1 },
                         username: { type: :string, example: 'testuser' },
                         first_name: { type: :string, example: 'Test' },
                         last_name: { type: :string, example: 'User' }
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
                   items: { type: :string, example: 'Username can\'t be blank' }
                 }
               }

        run_test!
      end
    end
  end
end
