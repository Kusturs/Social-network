# frozen_string_literal: true

class PostSerializer < Panko::Serializer
  attributes :id, :content

  has_many :comments, serializer: Comments::RootSerializer
end
