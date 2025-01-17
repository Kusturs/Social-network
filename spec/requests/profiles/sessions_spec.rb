require 'swagger_helper'

RSpec.describe 'Profiles::Sessions API', type: :request do
  let(:user) { create(:user) }
  let(:profile) { create(:profile, user: user, password: 'password123') }

  path '/login' do
    post 'Creates a session (logs in)' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :login_params, in: :body, schema: {
        type: :object,
        properties: {
          profile: {
            type: :object,
            properties: {
              email: { type: :string, example: 'user@example.com' },
              password: { type: :string, example: 'password123' }
            },
            required: ['email', 'password']
          }
        },
        required: ['profile']
      }

      response '200', 'session created' do
        let(:login_params) do
          {
            profile: {
              email: profile.email,
              password: 'password123'
            }
          }
        end

        schema type: :object,
               properties: {
                 message: { type: :string, example: 'Logged in successfully.' },
                 token: { type: :string, example: 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxMjMifQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c' }
               },
               required: ['message', 'token']

        run_test!
      end

      response '401', 'unauthorized' do
        let(:login_params) do
          {
            profile: {
              email: profile.email,
              password: 'wrong_password'
            }
          }
        end

        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Invalid Email or password.' }
               },
               required: ['error']

        run_test!
      end
    end
  end

  path '/logout' do
    delete 'Destroys a session (logs out)' do
      tags 'Authentication'
      produces 'application/json'
      security [bearer_auth: []]

      response '200', 'logged out successfully' do
        let(:token) { Warden::JWTAuth::UserEncoder.new.call(profile, :profile, nil).first }
        let(:Authorization) { "Bearer #{token}" }

        schema type: :object,
               properties: {
                 status: { type: :integer, example: 200 },
                 message: { type: :string, example: 'Logged out successfully.' }
               },
               required: ['status', 'message']

        run_test!
      end

      response '401', 'unauthorized' do
        let(:payload) do
          {
            sub: 'invalid_user_id',
            exp: (Time.zone.now + 1.week).to_i,
            jti: SecureRandom.uuid,
            scp: 'profile'
          }
        end
        let(:invalid_token) { JWT.encode(payload, Rails.application.credentials.fetch(:secret_key_base), 'HS256') }
        let(:Authorization) { "Bearer #{invalid_token}" }

        before do
          allow_any_instance_of(Warden::JWTAuth::TokenRevoker).to receive(:call).and_return(nil)
        end

        schema type: :object,
               properties: {
                 status: { type: :integer, example: 401 },
                 message: { type: :string, example: "Couldn't find an active session." }
               },
               required: ['status', 'message']

        run_test!
      end
    end
  end
end
