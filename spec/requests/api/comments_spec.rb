require 'swagger_helper'

RSpec.describe 'Comments API', type: :request do
  path '/posts/{post_id}/comments' do
    get 'Get comments' do
      tags 'Comments'
      produces 'application/json'
      parameter name: :post_id, in: :path, type: :integer, required: true
      parameter name: :page, in: :query, type: :integer, required: false
      parameter name: :items, in: :query, type: :integer, required: false
      parameter name: :parent_id, in: :query, type: :integer, required: false

      response '200', 'comments list' do
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
                      username: { type: :string }
                    }
                  },
                  created_at: { type: :string, format: 'date-time' }
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

        let(:post) { create(:post) }
        let(:post_id) { post.id }
        let!(:comments) { create_list(:comment, 3, post: post) }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(response).to have_http_status(:ok)
          expect(data['comments']).to be_an(Array)
          expect(data['comments'].length).to eq(3)
          expect(data['pagination']).to be_a(Hash)
          expect(data['pagination']).to include('count', 'page', 'items', 'pages')
        end
      end

      response '404', 'Post not found' do
        let(:post_id) { 'invalid' }

        run_test! do |response|
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    post 'Create a comment' do
      tags 'Comments'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :post_id, in: :path, type: :integer, required: true
      parameter name: :comment, in: :body, schema: {
        type: :object,
        properties: {
          content: { type: :string },
          parent_id: { type: :integer, nullable: true }
        },
        required: ['content']
      }

      response '201', 'comment created' do
        let(:post) { create(:post) }
        let(:post_id) { post.id }
        let(:comment) { { content: 'A new comment' } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(response).to have_http_status(:created)
          expect(data['content']).to eq('A new comment')
        end
      end

      response '422', 'invalid request' do
        let(:post) { create(:post) }
        let(:post_id) { post.id }
        let(:comment) { { content: '' } }

        run_test! do |response|
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  path '/comments/{id}' do
    get 'Get a comment' do
      tags 'Comments'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, required: true

      response '200', 'comment found' do
        let(:comment) { create(:comment) }
        let(:id) { comment.id }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(response).to have_http_status(:ok)
          expect(data['id']).to eq(comment.id)
        end
      end

      response '404', 'comment not found' do
        let(:id) { 'invalid' }

        run_test! do |response|
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    patch 'Update a comment' do
      tags 'Comments'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, required: true
      parameter name: :comment, in: :body, schema: {
        type: :object,
        properties: {
          content: { type: :string }
        },
        required: ['content']
      }

      response '200', 'comment updated' do
        let(:comment) { create(:comment) }
        let(:id) { comment.id }
        let(:comment_params) { { content: 'Updated content' } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(response).to have_http_status(:ok)
          expect(data['content']).to eq('Updated content')
        end
      end

      response '422', 'invalid request' do
        let(:comment) { create(:comment) }
        let(:id) { comment.id }
        let(:comment_params) { { content: '' } }

        run_test! do |response|
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    delete 'Delete a comment' do
      tags 'Comments'
      parameter name: :id, in: :path, type: :integer, required: true

      response '204', 'comment deleted' do
        let(:comment) { create(:comment) }
        let(:id) { comment.id }

        run_test! do |response|
          expect(response).to have_http_status(:no_content)
          expect(Comment.exists?(id)).to be false
        end
      end

      response '404', 'comment not found' do
        let(:id) { 'invalid' }

        run_test! do |response|
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
