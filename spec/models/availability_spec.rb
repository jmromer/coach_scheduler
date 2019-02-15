# frozen_string_literal: true

require "rails_helper"

RSpec.describe Availability, type: :model do
  it { should belong_to(:coach) }
  it { should validate_presence_of(:coach) }
  it { should validate_presence_of(:start_dt) }
  it { should validate_presence_of(:end_dt) }
  it { should have_db_index(:start_dt) }
  it { should have_db_index(:end_dt) }

  before do
    Timecop.travel(Time.zone.parse("Monday 1/14 9am UTC+0"))
  end

  describe ".build_attrs_within_range" do
    it "returns an array of hashes, each with Availability attrs" do
      coach = build_stubbed(:coach)

      entries = described_class.build_attrs_within_range(
        coach: coach,
        day_of_week: "Monday",
        local_start_time: "9am",
        local_end_time: "5pm",
        interval_length_mins: 60,
        number_of_weeks: 1,
      )

      expect(entries).to be_an_instance_of Array
      expect(entries).to all(be_an_instance_of(Hash))
      expect(entries.length).to eq 8

      expected_keys = %i[coach_id start_dt end_dt]
      expect(entries.map(&:keys).flatten.uniq).to eq(expected_keys)

      expect(coach.id).to be_an_instance_of Integer
      expect(entries.map { |e| e[:coach_id] }.uniq.first).to eq coach.id
    end

    it "returns the correct number of intervals within a day" do
      entries = described_class.build_attrs_within_range(
        coach: build_stubbed(:coach),
        day_of_week: "Monday",
        local_start_time: "9am",
        local_end_time: "5pm",
        interval_length_mins: 60,
        number_of_weeks: 1,
      )

      expect(entries.length).to eq 8
    end

    it "builds the correct number of intervals across multiple weeks" do
      entries = described_class.build_attrs_within_range(
        coach: build_stubbed(:coach),
        day_of_week: "Monday",
        local_start_time: "9am",
        local_end_time: "5pm",
        interval_length_mins: 30,
        number_of_weeks: 2,
      )

      expect(entries.length).to eq 8 * 2 * 2
    end

    it "returns an empty array if times have no overlap" do
      entries = described_class.build_attrs_within_range(
        coach: build_stubbed(:coach),
        day_of_week: "Monday",
        local_start_time: "8pm",
        local_end_time: "8am",
        interval_length_mins: 30,
        number_of_weeks: 2,
      )

      expect(entries).to be_empty
    end

    it "returns times normalized as UTC" do
      coach = build_stubbed(:coach, :eastern_time)
      expect(coach.utc_offset).to eq(-5)

      entries = described_class.build_attrs_within_range(
        coach: coach,
        day_of_week: "Monday",
        local_start_time: "10am",
        local_end_time: "12pm",
        interval_length_mins: 60,
        number_of_weeks: 1,
      )

      expect(entries.length).to eq 2
      expect(entries.first[:start_dt].hour).to eq 15
      expect(entries.first[:end_dt].hour).to eq 16
      expect(entries.last[:start_dt].hour).to eq 16
      expect(entries.last[:end_dt].hour).to eq 17
    end
  end
end
