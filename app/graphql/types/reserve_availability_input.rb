# frozen_string_literal: true

module Types
  class ReserveAvailabilityInput < Types::BaseInputObject
    description "Attributes for reserving an availability."

    argument :id, ID, "Availability slot id", required: true
  end
end
