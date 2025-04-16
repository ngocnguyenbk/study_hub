# frozen_string_literal: true

module Types
  class GroupStatusType < Types::BaseEnum
    description "Group status enum"

    value "ACTIVE", "The group is active", value: :active
    value "INACTIVE", "The group is inactive", value: :inactive
  end
end
