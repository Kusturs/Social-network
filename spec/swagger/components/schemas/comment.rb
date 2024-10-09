module Swagger
  module Components
    class Comment
      def self.schema
        {
          type: :object,
          properties: {
            id: { type: :integer },
            content: { type: :string },
            author: { '$ref' => '#/components/schemas/user' },
            created_at: { type: :string, format: 'date-time' },
            updated_at: { type: :string, format: 'date-time' },
            parent_id: { type: :integer, nullable: true }
          },
          required: %w[id content author created_at updated_at]
        }
      end
    end
  end
end
