# frozen_string_literal: true

module Types
  class AvailabilityType < Types::BaseObject
    field :id, ID, null: false

    field :start_dt,
          String,
          null: false,
          description: "Availability start time (UTC)."

    field :end_dt,
          String,
          null: false,
          description: "Availability start time (UTC)."

    field :start_dt_local,
          String,
          null: false,
          description: "Start time in the coach's local time zone."

    field :end_dt_local,
          String,
          null: false,
          description: "End time in the coach's local time zone."

    field :localized_label,
          String,
          null: false,
          description: "A human-friendly label for the time slot, in the associated coach's local time."

    field :coach,
          CoachType,
          null: false,
          description: "The coach available at this time slot."
  end
end
