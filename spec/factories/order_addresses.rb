FactoryBot.define do
  factory :order_address do
    postal_code { '123-4567' }
    prefecture_id { Faker::Number.between(from: 2, to: 48) }
    city { '東京都' }
    house_number { '1-1' }
    building { '日本ハイツ' }
    telephone{ '09012345678' }
    token {"tok_abcdefghijk00000000000000000"}
  end
end

