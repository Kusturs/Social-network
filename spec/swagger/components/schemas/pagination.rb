module Swagger
  module Components
    class Pagination
      def self.schema
        {
          type: :object,
          properties: {
            count: { type: :integer },
            page: { type: :integer },
            items: { type: :integer },
            pages: { type: :integer }
          },
          required: %w[count page items pages]
        }
      end
    end
  end
end
