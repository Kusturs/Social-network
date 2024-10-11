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
      security [bearer_auth: []]
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
               },
               example: {
                 comments: [
                   {
                     id: 1,
                     content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                     author: {
                       id: 1,
                       email: 'lorem@example.com'
                     }
                   },
                   {
                     id: 2,
                     content: 'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                     author: {
                       id: 2,
                       email: 'ipsum@example.com'
                     }
                   }
                 ],
                 pagination: {
                   count: 50,
                   page: 1,
                   items: 10,
                   pages: 5
                 }
               }

        let(:post_id) { existing_post.id }
        run_test!
      end
    end

    post 'Creates a comment' do
      tags 'Comments'
      security [bearer_auth: []]
      consumes 'application/json'

      parameter name: :comment_params, in: :body, schema: {
        type: :object,
        properties: {
          comment: {
            type: :object,
            properties: {
              content: { type: :string, example: 'New comment content' },
              parent_id: { type: :integer, required: false, example: 1, nullable: true }
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
      security [bearer_auth: []]
      produces 'application/json'

      response '200', 'comment found' do
        schema type: :object,
               properties: {
                 id: { type: :integer, example: 1 },
                 content: { type: :string,
                            example: 'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nariatur.' },
                 author: {
                   type: :object,
                   properties: {
                     id: { type: :integer, example: 1 },
                     email: { type: :string, example: 'lorem@example.com' }
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
      security [bearer_auth: []]
      consumes 'application/json'
      parameter name: :comment_params, in: :body, schema: {
        type: :object,
        properties: {
          comment: {
            type: :object,
            properties: {
              content: { type: :string, example: 'Updated comment content' }
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
      security [bearer_auth: []]

      response '204', 'comment deleted' do
        let(:id) { existing_comment.id }
        run_test!
      end
    end
  end
end
