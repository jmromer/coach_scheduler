# frozen_string_literal: true

FactoryBot.define do
  factory :appointment do
    start_dt { Time.current }
    end_dt { start_dt + 30.minutes }

    association :coach, factory: :coach
  end
end
