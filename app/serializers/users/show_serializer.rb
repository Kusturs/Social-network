# frozen_string_literal: true

module Users
  class ShowSerializer < IndexSerializer
    has_many :posts, serializer: Posts::LiteSerializer
  end
end
