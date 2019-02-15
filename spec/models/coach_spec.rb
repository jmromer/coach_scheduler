# frozen_string_literal: true

require "rails_helper"

RSpec.describe Coach, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:utc_offset) }
  it { should have_many(:availabilities) }
  it { should have_many(:appointments) }
  it { should have_db_column(:appointments_count) }
  it { should have_db_column(:availabilities_count) }
end
