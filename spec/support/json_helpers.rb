# frozen_string_literal: true

module JSONHelpers
  def response_json
    expect(response.body).to_not be_blank, response.body
    @_response_json ||= JSON.parse(response.body, symbolize_names: true)
  end

  def response_data
    expect(response_json).to have_key(:data), response_json.to_s
    expect(response_json).to_not have_key(:errors), response_json.to_s
    response_json[:data]
  end

  def response_errors
    expect(response_json).to_not have_key(:data), response_json.to_s
    expect(response_json).to have_key(:errors), response_json.to_s
    response_json[:errors]
  end
end

RSpec.configure do |config|
  config.include JSONHelpers
end
