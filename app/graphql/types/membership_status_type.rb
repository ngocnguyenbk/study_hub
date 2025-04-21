# frozen_string_literal: true

module Types
  class MembershipStatusType < Types::BaseEnum
    description "Membership status enum"

    value "PENDING", "The membership is pending", value: "pending"
    value "ACCEPTED", "The membership is accepted", value: "accepted"
    value "REJECTED", "The membership is rejected", value: "rejected"
  end
end
