FactoryBot.define do
  factory :merchant do
    name { "MyString" }
    description { "MyString" }
    email { "MyString" }
    status { "inactive" }
    total_transaction_sum { 1 }
  end
end
