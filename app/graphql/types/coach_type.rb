# frozen_string_literal: true

module Types
  class CoachType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :utc_offset, Integer, null: false

    field :appointments,
          [AppointmentType],
          null: false,
          description: "Appointments that have been booked."

    field :availabilities,
          [AvailabilityType],
          null: false,
          description: "Time slots available for booking."
  end
end
