FactoryBot.define do
  factory :transaction do
    uuid { "" }
    amount { 1 }
    status { "error" }
    customer_email { "MyString" }
    customer_phone { "MyString" }
  end
end
