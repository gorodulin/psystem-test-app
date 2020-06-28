FactoryBot.define do
  factory :merchant do
    user
    name { "Sea Star Store" }
    description { "yachts and shells" }
    email { "seller@store.com" }
    status { "inactive" }
    total_transaction_sum { 0 }
  end
end
