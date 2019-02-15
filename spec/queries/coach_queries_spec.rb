# frozen_string_literal: true

require "rails_helper"

RSpec.describe "coaches queries", type: :request do
  before do
    Timecop.travel(Time.zone.parse("Monday 1/14 9am UTC+0"))
  end

  it "returns an empty list if no coaches have been persisted" do
    Coach.delete_all

    query = <<~GQL
      {
        coaches {
          id
          name
        }
      }
    GQL

    post "/graphql", params: {query: query}

    expect(response).to be_ok
    expect(response_data[:coaches]).to be_empty
  end

  it "returns a complete list of coaches with any fields requested" do
    create(:coach, name: "UTC Coach")
    create(:coach, :eastern_time, name: "NYC Coach")

    query = <<~GQL
      {
        coaches {
          name
          utcOffset
        }
      }
    GQL

    post "/graphql", params: {query: query}

    expect(response).to be_ok
    expect(response_data[:coaches]).to eq([{name: "UTC Coach", utcOffset: 0},
                                           {name: "NYC Coach", utcOffset: -5}])
  end

  it "returns an errors list if the request is malformed" do
    query = <<~GQL
      {
        coaches {
          names
        }
      }
    GQL

    post "/graphql", params: {query: query}

    expect(response).to be_ok
    expect(response_errors.first[:message]).to match(/Field 'names' doesn't exist/)
  end

  it "returns associated availabilties if requested" do
    create(:coach_with_availabilities, availabilities_count: 3)

    query = <<~GQL
      {
        coaches {
          name
          availabilities {
            id
          }
        }
      }
    GQL

    post "/graphql", params: {query: query}

    coach = response_data[:coaches].first
    availabilities = coach[:availabilities]
    expect(availabilities.length).to eq 3
  end

  it "returns associated appointments if requested" do
    create(:coach_with_appointments, :eastern_time, appointments_count: 2)

    query = <<~GQL
      {
        coaches {
          name
          appointments {
            startDt
            endDt
            localizedLabel
          }
        }
      }
    GQL

    post "/graphql", params: {query: query}

    coach = response_data[:coaches].first
    appointments = coach[:appointments]
    expect(appointments.length).to eq 2
    expect(appointments.first[:startDt]).to eq "2019-01-14 09:00:00 UTC"
    expect(appointments.first[:endDt]).to eq "2019-01-14 09:30:00 UTC"
    expect(appointments.first[:localizedLabel]).to eq "Monday, January 14, from 4:00am to 4:30am"
  end
end
