# frozen_string_literal: true

module Users
  class IndexSerializer < Panko::Serializer
    attributes :id, :first_name, :last_name, :username, :second_name
  end
end
