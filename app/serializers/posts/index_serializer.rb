# frozen_string_literal: true

module Posts
  class IndexSerializer < LiteSerializer
    has_one :author, serializer: Users::ShowSerializer
  end
end
