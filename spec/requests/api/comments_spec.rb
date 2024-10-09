require 'swagger_helper'

RSpec.describe 'Comments API', type: :request do
  path '/posts/{post_id}/comments' do
    get 'Получить список комментариев' do
      tags 'Comments'
      produces 'application/json'
      parameter name: :post_id, in: :path, type: :integer, required: true
      parameter name: :page, in: :query, type: :integer, required: false
      parameter name: :items, in: :query, type: :integer, required: false

      response '200', 'список комментариев получен' do
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

      response '404', 'пост не найден' do
        let(:post_id) { 'invalid' }

        run_test! do |response|
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  
end
