# frozen_string_literal: true

module Comments
  class UserSerializer < Panko::Serializer
    attributes :id, :username
  end
end
