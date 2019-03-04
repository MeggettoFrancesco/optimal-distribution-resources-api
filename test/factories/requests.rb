FactoryBot.define do
  factory :request do
    ip_address { Faker::Internet.ip_v4_address }
    request_type { Request.request_type.values.sample }

    after(:build) do |request|
      build(request.request_type.to_sym, request: request)
    end
  end
end
