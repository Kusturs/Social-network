# frozen_string_literal: true

class UserSerializer < Panko::Serializer
  attributes :id, :first_name, :last_name, :username, :second_name
end
