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
                           first_name: { type: :string },
                           last_name: { type: :string },
                           username: { type: :string },
                           second_name: { type: :string }
                         }
                       },
                       comments_count: { type: :integer }
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
                 posts: [
                   {
                     id: 1,
                     content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dol.',
                     author: {
                       id: 1,
                       first_name: 'Lorem',
                       last_name: 'Ipsum',
                       username: 'lorem_ipsum',
                       second_name: 'Dolor'
                     },
                     comments_count: 5
                   },
                   {
                     id: 2,
                     content: 'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                     author: {
                       id: 2,
                       first_name: 'Duis',
                       last_name: 'Aute',
                       username: 'duis_aute',
                       second_name: 'Irure'
                     },
                     comments_count: 3
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

    post 'Creates a post' do
      tags 'Posts'
      security [bearer_auth: []]
      consumes 'application/json'

      parameter name: :post_params, in: :body, schema: {
        type: :object,
        properties: {
          content: { type: :string, example: 'New post content' }
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
                     first_name: { type: :string },
                     last_name: { type: :string },
                     username: { type: :string },
                     second_name: { type: :string }
                   }
                 },
                 comments: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       content: { type: :string },
                       created_at: { type: :string },
                       updated_at: { type: :string },
                       author: {
                         type: :object,
                         properties: {
                           id: { type: :integer },
                           username: { type: :string }
                         }
                       }
                     }
                   }
                 }
               },
               example: {
                 posts: [
                   {
                     id: 1,
                     content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et lua.',
                     author: {
                       id: 1,
                       first_name: 'Lorem',
                       last_name: 'Ipsum',
                       username: 'lorem_ipsum',
                       second_name: 'Dolor'
                     },
                     comments_count: 5
                   },
                   {
                     id: 2,
                     content: 'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                     author: {
                       id: 2,
                       first_name: 'Duis',
                       last_name: 'Aute',
                       username: 'duis_aute',
                       second_name: 'Irure'
                     },
                     comments_count: 3
                   }
                 ],
                 pagination: {
                   count: 100,
                   page: 1,
                   items: 20,
                   pages: 5
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
          content: { type: :string, example: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.' }
        }
      }

      response '200', 'post updated' do
        let(:id) { existing_post.id }
        let(:post_params) { { content: 'Lorem ipsum dolor sit amet' } }
        schema type: :object,
               properties: {
                 id: { type: :integer, example: 1 },
                 content: { type: :string, example: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.' },
                 author: {
                   type: :object,
                   properties: {
                     id: { type: :integer, example: 1 },
                     first_name: { type: :string, example: 'Lorem' },
                     last_name: { type: :string, example: 'Ipsum' },
                     username: { type: :string, example: 'lorem_ipsum' },
                     second_name: { type: :string, example: 'Dolor' }
                   }
                 },
                 comments_count: { type: :integer, example: 5 }
               }
        run_test!
      end

      response '422', 'invalid request' do
        let(:id) { existing_post.id }
        let(:post_params) { { content: '' } }
        schema type: :object,
               properties: {
                 errors: {
                   type: :object,
                   properties: {
                     content: {
                       type: :array,
                       items: { type: :string },
                       example: ["can't be blank"]
                     }
                   }
                 }
               }
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
