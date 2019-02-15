# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :reserve_availability,
          mutation: Mutations::ReserveAvailability do
      argument :input, Types::ReserveAvailabilityInput, required: true
    end
  end
end
