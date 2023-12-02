FactoryBot.define do
  factory :user do
    transient do
      person { Gimei.name }
    end
    nickname              { Faker::Name.initials }
    email                 { Faker::Internet.email }
    password              { Faker::Lorem.characters(number: 6..128, min_alpha: 1, min_numeric: 1) }
    password_confirmation { password }
    last_name             { Faker::Japanese::Name.last_name }
    first_name            { Faker::Japanese::Name.first_name }
    last_name_kana        { person.last.katakana }
    first_name_kana       { person.first.katakana }
    birth_date            { Faker::Date.between(from: '1930-01-01', to: '2018-12-31') }
  end
end
