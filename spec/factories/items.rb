FactoryBot.define do
  factory :item do
    product_name_max_length = 40
    product_name = Faker::Commerce.product_name
    product_name = product_name[0, product_name_max_length] if product_name.length > product_name_max_length

    paragraph_max_length = 1000
    paragraph = Faker::Lorem.paragraph
    paragraph = paragraph[0, paragraph_max_length] if paragraph.length > paragraph_max_length

    item_name              { product_name }
    item_info              { paragraph }
    category_id            { Faker::Number.within(range: 2..11) }
    sales_status_id        { Faker::Number.within(range: 2..7) }
    shipping_fee_status_id { Faker::Number.within(range: 2..3) }
    prefecture_id          { Faker::Number.within(range: 2..47) }
    scheduled_delivery_id  { Faker::Number.within(range: 2..4) }
    item_price             { Faker::Commerce.price(range: 300..9_999_999, as_string: true).split('.').first.to_i }

    association :user

    after(:build) do |item|
      item.image.attach(io: File.open('public/images/test_image.png'), filename: 'test_image.png')
    end
  end
end
