require 'swagger_helper'

RSpec.describe 'Comments API', type: :request do
  path '/posts/{post_id}/comments' do
    parameter name: 'post_id', in: :path, type: :integer, description: 'ID поста'

    get 'Получить список комментариев' do
      tags 'Комментарии'
      produces 'application/json'
      parameter name: 'parent_id', in: :query, type: :integer, required: false, description: 'ID родительского комментария'
      parameter name: 'page', in: :query, type: :integer, required: false, description: 'Номер страницы'
      parameter name: 'items', in: :query, type: :integer, required: false, description: 'Количество элементов на странице'

      response '200', 'список комментариев получен' do
        schema type: :object,
               properties: {
                 comments: {
                   type: :array,
                   items: { '$ref' => '#/components/schemas/comment' }
                 },
                 pagination: { '$ref' => '#/components/schemas/pagination' }
               }
        run_test!
      end
    end

    post 'Создать новый комментарий' do
      tags 'Комментарии'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :comment, in: :body, schema: {
        type: :object,
        properties: {
          content: { type: :string },
          parent_id: { type: :integer, nullable: true }
        },
        required: ['content']
      }

      response '201', 'комментарий создан' do
        schema '$ref' => '#/components/schemas/comment'
        run_test!
      end

      response '422', 'неверные параметры' do
        schema '$ref' => '#/components/schemas/errors'
        run_test!
      end
    end
  end

  path '/comments/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'ID комментария'

    get 'Получить комментарий' do
      tags 'Комментарии'
      produces 'application/json'

      response '200', 'комментарий найден' do
        schema '$ref' => '#/components/schemas/comment'
        run_test!
      end

      response '404', 'комментарий не найден' do
        schema '$ref' => '#/components/schemas/error'
        run_test!
      end
    end

    patch 'Обновить комментарий' do
      tags 'Комментарии'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :comment, in: :body, schema: {
        type: :object,
        properties: {
          content: { type: :string }
        },
        required: ['content']
      }

      response '200', 'комментарий обновлен' do
        schema '$ref' => '#/components/schemas/comment'
        run_test!
      end

      response '422', 'неверные параметры' do
        schema '$ref' => '#/components/schemas/errors'
        run_test!
      end
    end

    delete 'Удалить комментарий' do
      tags 'Комментарии'
      produces 'application/json'

      response '204', 'комментарий удален' do
        run_test!
      end

      response '409', 'конфликт при удалении' do
        schema '$ref' => '#/components/schemas/error'
        run_test!
      end
    end
  end
end
