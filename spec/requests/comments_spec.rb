require 'swagger_helper'

RSpec.describe 'Comments API', type: :request do
  let(:user) { create(:user) }
  let(:profile) { create(:profile, user: user) }
  let(:token) { Warden::JWTAuth::UserEncoder.new.call(profile, :profile, nil).first }
  let(:Authorization) { "Bearer #{token}" }
  let(:existing_post) { create(:post) }
  let(:existing_comment) { create(:comment, author: user, post: existing_post) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  path '/posts/{post_id}/comments' do
    parameter name: 'post_id', in: :path, type: :integer, description: 'post id'

    get 'Lists all comments for a post' do
      tags 'Comments'
      security [ bearer_auth: [] ]
      produces 'application/json'
      parameter name: :parent_id, in: :query, type: :integer, required: false, description: 'Parent comment ID'

      response '200', 'comments found' do
        schema type: :object,
          properties: {
            comments: {
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

        let(:post_id) { existing_post.id }
        run_test!
      end
    end

    post 'Creates a comment' do
      tags 'Comments'
      security [ bearer_auth: [] ]
      consumes 'application/json'

      parameter name: :comment_params, in: :body, schema: {
        type: :object,
        properties: {
          comment: {
            type: :object,
            properties: {
              content: { type: :string },
              parent_id: { type: :integer }
            },
            required: ['content']
          }
        }
      }

      response '201', 'comment created' do
        let(:post_id) { existing_post.id }
        let(:comment_params) { { comment: { content: 'New comment content' } } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:post_id) { existing_post.id }
        let(:comment_params) { { comment: { content: nil } } }
        run_test!
      end
    end
  end

  path '/comments/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'comment id'

    get 'Retrieves a comment' do
      tags 'Comments'
      security [ bearer_auth: [] ]
      produces 'application/json'

      response '200', 'comment found' do
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
            }
          }

        let(:id) { existing_comment.id }
        run_test!
      end

      response '404', 'comment not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Updates a comment' do
      tags 'Comments'
      security [ bearer_auth: [] ]
      consumes 'application/json'
      parameter name: :comment_params, in: :body, schema: {
        type: :object,
        properties: {
          comment: {
            type: :object,
            properties: {
              content: { type: :string }
            },
            required: ['content']
          }
        }
      }

      response '200', 'comment updated' do
        let(:id) { existing_comment.id }
        let(:comment_params) { { comment: { content: 'Updated content' } } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:id) { existing_comment.id }
        let(:comment_params) { { comment: { content: '' } } }
        run_test!
      end
    end

    delete 'Deletes a comment' do
      tags 'Comments'
      security [ bearer_auth: [] ]

      response '204', 'comment deleted' do
        let(:id) { existing_comment.id }
        run_test!
      end
    end
  end
end
