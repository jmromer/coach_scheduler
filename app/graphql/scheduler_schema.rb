# frozen_string_literal: true

class SchedulerSchema < GraphQL::Schema
  mutation Types::MutationType
  query Types::QueryType
end
