module Swagger
  module Components
    class Errors
      def self.schema
        {
          type: :object,
          properties: {
            errors: { 
              type: :object, 
              additionalProperties: { 
                type: :array, 
                items: { type: :string } 
              } 
            }
          },
          required: ['errors']
        }
      end
    end
  end
end