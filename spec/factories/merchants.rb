FactoryBot.define do
  factory :merchant do
    user
    name { Faker::Name.name }
    description { Faker::Company.bs }
    email { Faker::Internet.email }
    status { "active" }
    total_transaction_sum { 0 }
  end
end
