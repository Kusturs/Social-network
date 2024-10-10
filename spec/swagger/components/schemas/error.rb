module Swagger
  module Components
    class Error
      def self.schema
        {
          type: :object,
          properties: {
            error: { type: :string }
          },
          required: ['error']
        }
      end
    end
  end
end
