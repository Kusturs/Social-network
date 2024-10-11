require 'swagger_helper'

RSpec.describe 'Posts API', type: :request do
  let(:user) { create(:user) }
  let(:profile) { create(:profile, user: user) }
  let(:token) { Warden::JWTAuth::UserEncoder.new.call(profile, :profile, nil).first }
  let(:Authorization) { "Bearer #{token}" }
  let(:existing_post) { create(:post, author: user) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  path '/posts' do
    get 'Lists all posts' do
      tags 'Posts'
      security [bearer_auth: []]
      produces 'application/json'

      response '200', 'posts found' do
        schema type: :object,
               properties: {
                 posts: {
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
                           email: { type: :string }
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

    post 'Creates a post' do
      tags 'Posts'
      security [bearer_auth: []]
      consumes 'application/json'

      parameter name: :post_params, in: :body, schema: {
        type: :object,
        properties: {
          content: { type: :string }
        },
        required: ['content']
      }

      response '201', 'post created' do
        let(:post_params) { { content: 'New post content' } }
        run_test!
      end
    end
  end

  path '/posts/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'post id'

    get 'Retrieves a post' do
      tags 'Posts'
      security [bearer_auth: []]
      produces 'application/json'

      response '200', 'post found' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 content: { type: :string },
                 author: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     email: { type: :string }
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

        let(:id) { existing_post.id }
        run_test!
      end

      response '404', 'post not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Updates a post' do
      tags 'Posts'
      security [bearer_auth: []]
      consumes 'application/json'

      parameter name: :post_params, in: :body, schema: {
        type: :object,
        properties: {
          content: { type: :string }
        }
      }

      response '200', 'post updated' do
        let(:id) { existing_post.id }
        let(:post_params) { { content: 'Updated content' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:id) { existing_post.id }
        let(:post_params) { { content: '' } }
        run_test!
      end
    end

    delete 'Deletes a post' do
      tags 'Posts'
      security [bearer_auth: []]

      response '204', 'post deleted' do
        let(:id) { existing_post.id }
        run_test!
      end
    end
  end
end
