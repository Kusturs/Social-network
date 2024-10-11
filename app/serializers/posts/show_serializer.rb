# frozen_string_literal: true

module Posts
  class ShowSerializer < Panko::Serializer
    attributes :id, :content

    has_one :author, serializer: UserSerializer
    has_many :comments, serializer: Comments::RootSerializer
  end
end
