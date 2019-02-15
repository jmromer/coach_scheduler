# frozen_string_literal: true

Availability.delete_all
Appointment.delete_all
Coach.delete_all

require "csv"

# Load seed data from CSV
CSV.foreach(Rails.root.join("data", "data.csv"), headers: true) do |record|
  coach_name = record["Name"]
  utc_offset = record["Timezone"].match(/.+GMT(.+):.+/)[1].to_i

  day_of_week = record["Day of Week"]
  availability_start = record["Available at"]
  availability_end = record["Available until"]

  coach = Coach.find_or_create_by!(name: coach_name, utc_offset: utc_offset)
  puts "\nCreating availabilities for #{coach}..."

  # Default to creating recurring availabilities one month into the future
  availabilities_attrs = Availability.build_attrs_within_range(
    coach: coach,
    day_of_week: day_of_week,
    local_start_time: availability_start,
    local_end_time: availability_end,
    number_of_weeks: 4,
  )

  # TODO: Bulk insert
  availabilities = Availability.create!(availabilities_attrs)

  puts "Created #{availabilities.length} available booking times."
end
