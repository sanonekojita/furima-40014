FactoryBot.define do
  factory :user do
    nickname              {Faker::Name.initials}
    email                 {Faker::Internet.email}
    password              {Faker::Internet.password(min_length: 6)}
    password_confirmation {password}
    last_name             {Faker::Japanese::Name.last_name}
    first_name            {Faker::Japanese::Name.first_name}
    last_name_kana        {Faker::Japanese::Name.last_name_kana}
    first_name_kana       {Faker::Japanese::Name.first_name_kana}
    birth_date            {Faker::Date..between(from: '1930-01-01', to: '2018-12-31')}
  end
end
