def generate_japanese_postal_code
  "#{Faker::Number.number(digits: 3)}-#{Faker::Number.number(digits: 4)}"
end

FactoryBot.define do
  factory :purchase_record_shipping_address do
    token         { Faker::Number.number(digits: rand(15..16)) }
    postal_code   { generate_japanese_postal_code }
    prefecture_id { Faker::Number.within(range: 2..47) }
    city          { Faker::Address.city }
    addresses     { Faker::Address.street_address }
    building      { Faker::Address.secondary_address }
    phone_number  { Faker::Number.number(digits: rand(11..12)) }

    association :user
    association :item
  end
end
