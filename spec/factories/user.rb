FactoryBot.define do
  factory :user do
    transient do
      person {Gimei.name}
    end
    nickname              {Faker::Name.initials(number: 2)}
    email                 {Faker::Internet.free_email}
    password = Faker::Lorem.characters(number: 6, min_alpha: 1, min_numeric: 1)
    password              {password}
    password_confirmation {password}
    last_name             {'山だダ'}
    first_name            {'たロ宇'}
    last_name_kana        {person.last.katakana}
    first_name_kana       {person.first.katakana}
    birthday              {Faker::Date.backward}
  end
end