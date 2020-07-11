FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    password { Faker::Alphanumeric.alphanumeric(number: 10) }
    email { Faker::Internet.email }
    is_admin { false }
  end
end

