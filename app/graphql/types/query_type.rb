# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :coaches,
          [CoachType],
          null: false,
          description: "List all coaches."

    field :appointments,
          [AppointmentType],
          null: false,
          description: "List all appointments."

    def coaches
      Coach.includes(:availabilities).all
    end

    def appointments
      Appointment.includes(:coach).all
    end
  end
end
