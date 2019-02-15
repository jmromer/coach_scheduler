# frozen_string_literal: true

class Availability < ApplicationRecord
  include LocalizationMixin

  belongs_to :coach, counter_cache: true
  validates :coach, presence: true
  validates :start_dt, presence: true
  validates :end_dt, presence: true

  def book_appointment!
    transaction do
      appointment =
        coach
          .appointments
          .create(start_dt: start_dt, end_dt: end_dt)
      destroy
      appointment
    end
  end

  alias to_s to_localized_string

  # Given a specific coach, a day of the week, and start and end times in
  # coach's local time, build an array of Availability attribute-hashes suitable
  # for persisting, where each attribute hash represents an availability
  # timeslot of duration `interval_length_mins` (default: 30 minutes).
  #
  # Unless a `number_of_weeks` argument is provided, default to a non-recurring
  # schedule.
  #
  # Keyword Arguments:
  #
  #    coach [Coach]
  #    day_of_week [String]: "Wednesday"
  #    local_start_time [String]: "05:00AM"
  #    local_end_time [String]: "10:00AM"
  #    interval_length_mins [Integer]: 30 (default)
  #    number_of_weeks [Integer]: 1 (default)
  #
  # Returns (example):
  #
  #    [
  #      {
  #        coach_id: 1,
  #        start_dt: <Thu, 07 Feb 2019 22:30:00 UTC +00:00>,
  #        end_dt: <Thu, 07 Feb 2019 23:00:00 UTC +00:00>
  #      },
  #      {. . .},
  #    ]
  #
  def self.build_attrs_within_range(coach:,
                                    day_of_week:,
                                    local_start_time:,
                                    local_end_time:,
                                    interval_length_mins: 30,
                                    number_of_weeks: 1)
    interval_length_mins = Integer(interval_length_mins)
    number_of_weeks = Integer(number_of_weeks)

    if interval_length_mins < 1 || number_of_weeks < 1
      raise ArgumentError, "Invalid duration."
    end

    next_date = Date.current.next_occurring(day_of_week.downcase.to_sym)
    start_str = "#{next_date} #{local_start_time} UTC#{coach.utc_offset}"
    end_str = "#{next_date} #{local_end_time} UTC#{coach.utc_offset}"

    availability_entries = []

    number_of_weeks.times do |week_num|
      utc_start = Time.zone.parse(start_str) + week_num.weeks
      utc_end = Time.zone.parse(end_str) + week_num.weeks

      curr_start = utc_start # TODO: round to nearest interval start

      loop do
        curr_end = curr_start + interval_length_mins.minutes
        break if curr_end > utc_end

        entry = {
          coach_id: coach.id,
          start_dt: curr_start,
          end_dt: curr_start + interval_length_mins.minutes,
        }

        availability_entries << entry

        curr_start = curr_end
      end
    end

    availability_entries
  end
end
