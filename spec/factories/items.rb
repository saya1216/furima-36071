FactoryBot.define do
  factory :item do
    item_name        { Faker::Lorem.characters(number: 40) }
    information      { Faker::Lorem.characters(number: 1_000) }
    category_id      { Faker::Number.between(from: 2, to: 11) }
    sales_status_id  { Faker::Number.between(from: 2, to: 7) }
    shipping_cost_id { Faker::Number.between(from: 2, to: 3) }
    prefecture_id    { Faker::Number.between(from: 2, to: 48) }
    shipping_days_id { Faker::Number.between(from: 2, to: 4) }
    price            { Faker::Number.within(range: 300..9_999_999) }
    association :user

    after(:build) do |item|
      item.image.attach(io: File.open('public/images/test_image.jpg'), filename: 'test_image.jpg')
    end
  end
end
