# frozen_string_literal: true

module Comments
  class RootSerializer < Panko::Serializer
    attributes :id, :content, :created_at, :updated_at

    has_one :author, serializer: ::Comments::UserSerializer
  end
end
