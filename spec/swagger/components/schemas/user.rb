module Swagger
  module Components
    class User
      def self.schema
        {
          type: :object,
          properties: {
            id: { type: :integer },
            username: { type: :string }
          },
          required: %w[id username]
        }
      end
    end
  end
end
