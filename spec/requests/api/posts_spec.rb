require 'swagger_helper'

describe 'posts', type: :request do
  path '/posts' do
    get 'returns all posts' do
      tags 'Posts'
      produces 'application/json'

      response '200', 'posts found' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              content: { type: :string },
              author: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  username: { type: :string },
                  first_name: { type: :string },
                  second_name: { type: :string },
                  last_name: { type: :string }
                }
              }
            }
        }

        run_test!
      end

      response '401', 'unauthorized' do
        run_test!
      end
    end
  end
end
