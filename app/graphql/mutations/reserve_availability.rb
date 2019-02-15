# frozen_string_literal: true

module Mutations
  class ReserveAvailability < BaseMutation
    description <<~DESC
                  Book the given availability slot and return the created appointment
                  record.
                DESC

    field :appointment, Types::AppointmentType, null: true
    field :errors, [String], null: false

    def resolve(input)
      availability = Availability.find_by(id: input[:id])

      if availability.nil?
        return {appointment: nil, errors: ["Sorry, that time slot is no longer available."]}
      end

      appointment = availability.book_appointment!

      if appointment.persisted?
        {appointment: appointment, errors: []}
      else
        {appointment: nil, errors: appointment.errors.full_messages}
      end
    end
  end
end
