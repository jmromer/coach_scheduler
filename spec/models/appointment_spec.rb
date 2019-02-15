# frozen_string_literal: true

require "rails_helper"

RSpec.describe Appointment, type: :model do
  it { should belong_to(:coach) }
  it { should validate_presence_of(:coach) }
  it { should validate_presence_of(:start_dt) }
  it { should validate_presence_of(:end_dt) }
  it { should have_db_index(:start_dt) }
  it { should have_db_index(:end_dt) }
end
